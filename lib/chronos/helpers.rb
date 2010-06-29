module Chronos
  module Helpers
    def bucket
      @bucket ||= Chronos.riak.bucket(bucket_name)
    end
    
    def riak_object
      @riak_object ||= bucket.new(key)
    end
    
    def path
      @path ||= [bucket_name, key].join('/')
    end
    
    def walk_string(tag = nil, keep = false)
      walk_spec(tag, keep).to_s
    end
    
    def walk_spec(tag = nil, keep = false)
      Riak::WalkSpec.new(bucket_name, tag, keep)
    end
    
    def exists? 
      @exists ||= (key.blank? ? false : bucket.exists?(key))
    end
    
    def link_for(tag)
      Riak::Link.new("/riak/#{path}", tag)
    end
  end
end