module Chronos
  RESOLUTIONS = [:year, :month, :day, :hour, :minute, :second]
  class Resolution
    include Helpers
    
    attr_accessor :name, :time
    def initialize(name, time = Time.now)
      @name, @time = name, time
    end
    
    def index
      @index ||= RESOLUTIONS.index(name)
    end
    
    def tag
      @tag ||= time.to_s(name)
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
    
    def links
      @links ||= parent.blank? ? [] : parent.links.push(parent.link)
    end
    
    def parent
      return @parent if @parent
      return nil unless (parent_index = index - 1) >= 0
      parent_period = RESOLUTIONS[parent_index]
      return nil if parent_period.blank?
      @parent = self.class.new(parent_period, time)
    end
    
    def link
      @link ||= link_for("#{child.bucket_name}:#{tag}")
    end
    
    def child
      return @child if @child
      child_period = RESOLUTIONS[index + 1]
      return nil if child_period.blank?
      @child = self.class.new(child_period, time)
    end
    
    def save
      unless exists?
        riak_object.links = links
        riak_object.store
      end
    end
  end
end