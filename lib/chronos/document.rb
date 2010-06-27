module Chronos
  module Document
    def self.included(klass)
      klass.extend ClassMethods
      klass.extend Helpers
      klass.send(:include, Helpers)
      klass.send(:attr_accessor, *[:key, :attributes, :time])
      klass.cattr_accessor :resolution_period
    end
    
    module ClassMethods
      def get(id)
        bucket.get(id)
      end
      
      def resolution(period)
        self.resolution_period = period
      end
      
      def epoch(resolution = :hour, time = Time.now)
        res_instance = Resolution.new(resolution, time)
        "/#{res_instance.path}/#{bucket_name},_,_"
      end
      
      def period(resolution = :hour, start = 1.day.ago, stop = Time.now)
        res_instance = Resolution.new(:hour)
        keys = (start..stop).send(:"to_#{res_instance.bucket_name}")
        keys.map! do |time|
          res_instance.time = time
          res_instance.key
        end
        keys
      end
    end
    
    def initialize(time = Time.now, params = {})
      @time, @attributes = time, params
    end
    
    def links
      @links = resolutions.map(&:link)
    end
    
    def resolutions
      @resolutions ||= RESOLUTIONS[0..resolution_index].map{|period| Resolution.new(period, time)}
    end
    
    def resolution_index
      @resolution_index ||= RESOLUTIONS.index(self.class.resolution_period)
    end
    
    def method_missing(method_symbol, *args)
      method_name = method_symbol.to_s
      if %w(? =).include?(method_name[-1,1])
        method = method_name[0..-2]
        operator = method_name[-1,1]
        if operator == '='
          set_value(method, args.first)
        elsif operator == '?'
          !@attributes[method].blank?
        end
      else 
        @attributes[method_name]
      end
    end
    
    def set_value(method, val)
      if val.blank?
        @attributes.delete(method)
      else
        @attributes[method] = val
      end
    end
    
    def bucket_name
      @bucket_name ||= self.class.bucket_name
    end
    
    def save
      if key.blank?
        p 'POST'
      else
        p 'PUT'
      end
    end
  end
end