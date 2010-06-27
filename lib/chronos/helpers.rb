module Chronos
  module Helpers
    def bucket_name
      @bucket_name ||= name.to_s.tableize
    end
    
    def bucket
      @bucket ||= Chronos.riak.bucket(bucket_name)
    end
    
    def riak_object
      @riak_object ||= bucket.new
    end
    
    def path
      @path ||= [bucket_name, key].join('/')
    end
    
    def walk_string(tag = nil, keep = false)
      "#{bucket_name},#{tag || '_'},#{keep ? '1' : '_'}"
    end
    
    def exists? 
      @exists ||= bucket.exists?(key)
    end
  end
end