module Timemaster
  RESOLUTIONS = [:year, :month, :day, :hour, :minute, :second]
  class Resolution
    include Helpers
    
    def self.index(resolution)
      RESOLUTIONS.index(resolution)
    end
    
    attr_accessor :name, :time
    def initialize(name, time)
      @name = name
      @time = case time
      when Time then
        time
      when String
        Time.utc(*time.split('_'))
      when Nil
        Time.now.utc
      end
    end
    
    def index
      @index ||= self.class.index(name)
    end
    
    def default_tag
      return @tag if @tag
      return nil unless @time
      @tag = @time.to_s(name)
    end
    
    def prev
      (index >= 1) ? RESOLUTIONS[index - 1] : nil
    end
    
    def next
      RESOLUTIONS[index + 1]
    end
    
    def bucket_name
      @bucket_name ||= name.to_s.tableize
    end
    
    def update_links!(*args)
      obj = bucket.get(key)
      obj.links.merge args.flatten
      obj.store
    end
    
    def key
      return @key if @key
      # join string up to resolution and user to format time
      return @key = nil if index.blank?
      @key = RESOLUTIONS[0..index].inject(''){|str, res| "#{str}_#{time.to_s(res)}"}[1..-1]
    end
    
    def link
      @link ||= link_for(default_tag)
    end
  end
end