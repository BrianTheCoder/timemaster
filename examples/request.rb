require File.join(File.dirname(__FILE__),'../lib/chronos')

Chronos.riak.port = 8091

class Request
  include Chronos::Document
  
  resolution :minute
  
  tag :controller_name
  tag :action_name
end