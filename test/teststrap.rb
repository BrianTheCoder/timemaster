require 'rubygems'
require 'riot'
require 'chronos'
require 'timecop'

Chronos.riak.port = 8091

class Request
  include Chronos::Document
  
  resolution :minute
  
  tag :controller_name
  tag :action_name
end