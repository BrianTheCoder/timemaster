module Chronos
  RESOLUTIONS = [:year, :month, :day, :hour, :minute, :second]
  class Resolution
    include Helpers
    
    def self.index(resolution)
      RESOLUTIONS.index(resolution)
    end
    
    attr_accessor :name, :time
    def initialize(name, time = Time.now)
      @name, @time = name, time
    end
    
    def index
      @index ||= self.class.index(name)
    end
    
    def default_tag
      return @tag if @tag
      return nil unless @time
      @tag = @time.to_s(name)
    end
    
    def bucket_name
      @bucket_name ||= name.to_s.tableize
    end
    
    def key
      return @key if @key
      # join string up to resolution and user to format time
      return @key = nil if index.blank?
      @key = RESOLUTIONS[0..index].inject(''){|str, res| "#{str}_#{time.to_s(res)}"}[1..-1]
    end
    
    def parent
      return @parent if @parent
      return nil unless (parent_index = index - 1) >= 0
      parent_period = RESOLUTIONS[parent_index]
      return nil if parent_period.blank?
      @parent = self.class.new(parent_period, time)
    end
    
    def link
      @link ||= child.link_for(child.default_tag)
    end
    
    def child
      return @child if @child
      child_period = RESOLUTIONS[index + 1]
      return nil if child_period.blank?
      @child = self.class.new(child_period, time)
    end
    
    def update!
      old_object = bucket.get(key)
      links.merge old_object.links
      store
    end
    
    def save
      unless exists?
        self.links << link unless child.blank?
        store
      end
    end
  end
end