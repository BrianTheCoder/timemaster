module Chronos
  module Document
    def self.included(klass)
      klass.extend ClassMethods
      klass.extend Helpers
      klass.send(:include, Helpers)
      klass.send(:attr_accessor, *[:key, :attributes])
      klass.send(:attr_reader, :time)
      klass.cattr_accessor :resolution_period
      klass.cattr_accessor :indexed_keys
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
      
      def epoch(params = {})
        options = {
          :resolution => :hour,
          :time => Time.new,
          :keep => false }.merge(params)
        res_instance = Resolution.new(options[:resolution], options[:time])
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
      
      def tag(key, options = {})
        self.indexed_keys ||= []
        self.indexed_keys << key
      end
    end
    
    def initialize(params = {})
      case params
      when Hash
        @time = params.delete(:time) || Time.now.utc
        @attributes = Hashie::Mash.new(params)
      when Riak::RObject
        @riak_object = params
        @links = params.links
        @key = params.key
        @attributes = params.data
      end
    end
    
    def links
      @links ||= resolutions.map(&:link) + self.class.indexed_keys.map{|key| make_links_for(key)}.flatten.compact
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
    
    def make_links_for(tag)
      return nil unless @attributes.key?(tag)
      return resolutions.map{|res| res.link_for("#{tag}:#{@attributes[tag]}") }
    end
    
    def save
      resolutions.each(&:save)
      riak_object.data  = @attributes
      riak_object.links = links
      riak_object.store
    end
  end
end