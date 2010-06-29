module Chronos
  module Document
    def self.included(klass)
      klass.extend ClassMethods
      klass.extend Helpers
      klass.send(:include, Helpers)
      klass.send(:attr_accessor, :key)
      klass.send(:attr_reader, :time)
      klass.cattr_accessor :resolution_period
      klass.cattr_accessor :tags
    end
    
    module ClassMethods
      def get(id)
        begin
          new bucket.get(id)
        rescue Riak::FailedRequest
          nil
        end
      end
      
      def bucket_name
        @bucket_name ||= self.to_s.tableize
      end
      
      def resolution(period)
        self.resolution_period = period
      end
      
      def epoch(period = :hour, time = Time.now.utc, tag = nil)
        # res_instance = Resolution.new(options[:resolution], options[:time])
        index = Resolution.index(resolution_period)
        res_index = Resolution.index(period)
        resolutions = []
        RESOLUTIONS[0..index].each_with_index do |res_period, i| 
          resolutions[i] = Resolution.new(res_period, (i <= res_index) ? time : nil)
        end
        root = resolutions.shift.riak_object
        root.walk(resolutions.map(&:walk_spec).insert(-1, Riak::WalkSpec.new('requests', tag, true))).flatten
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
      
      def tag(new_tag, options = {})
        self.tags ||= []
        self.tags << new_tag
      end
    end
    
    def initialize(params = {})
      case params
      when Hash
        @time = params.delete(:time) || Time.now.utc
        riak_object.data = params
      when Riak::RObject
        self.riak_object = params
      end
    end
    
    def make_links
      return link_for if self.class.tags.blank?
      self.class.tags.map{|key| link_for("#{key}_#{data[key.to_s]}")}.flatten.compact
    end
    
    def time_from_link(link)
      Time.utc(*link.url.split('/').last.split('_'))
    end
    
    def resolutions
      @resolutions ||= RESOLUTIONS[0..resolution_index].map{|period| Resolution.new(period, time)}
    end
    
    def resolution_index
      @resolution_index ||= RESOLUTIONS.index(self.class.resolution_period)
    end
    
    def time=(timestamp)
      case timestamp
      when Date
        self.time = timestamp.to_time
      when Time
        @time = timestamp.utc
      when Riak::Link
        self.time = time_from_link(timestamp)
      end
    end
    
    def [](key)
      attributes[key]
    end
    
    def []=(key, value)
      attributes[key] = value
    end
    
    def method_missing(method_symbol, *args)
      method_name = method_symbol.to_s
      if %w(? =).include?(method_name[-1,1])
        method = method_name[0..-2]
        operator = method_name[-1,1]
        if operator == '='
          set_value(method, args.first)
        elsif operator == '?'
          !data[method].blank?
        end
      else 
        data[method_name]
      end
    end
    
    def set_value(method, val)
      if val.blank?
        data.delete(method)
      else
        data[method] = val
      end
    end
    
    def bucket_name
      @bucket_name ||= self.class.bucket_name
    end
    
    def save
      resolutions[0..-1].each(&:save)
      linked_res = resolutions.last
      store
      self.key = riak_object.key
      linked_res.links.merge make_links
      linked_res.update!
      self
    end
  end
end