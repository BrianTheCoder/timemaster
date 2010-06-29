module Chronos
  module Helpers
    def bucket
      @bucket ||= Chronos.riak.bucket(bucket_name)
    end
    
    def riak_object
      @riak_object ||= bucket.new(key)
    end
    
    delegate :walk, :links, :store, :data, :to => :riak_object
    
    def path
      @path ||= ['', 'riak', bucket_name, key].join('/')
    end
    
    def exists? 
      @exists ||= (key.blank? ? false : bucket.exists?(key))
    end
    
    def link_for(tag = nil)
      Riak::Link.new(path, tag)
    end
    
    def walk_spec(tag = nil, keep = false)
      Riak::WalkSpec.new(bucket_name, (tag||default_tag), keep)
    end
  end
end