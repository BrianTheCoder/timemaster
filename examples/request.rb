require File.join(File.dirname(__FILE__),'../lib/chronos')

require 'timecop'
require 'randexp'

Chronos.riak.port = 8091

class Request
  include Chronos::Document
  
  resolution :minute
  
  tag :controller_name
  tag :action_name
end

def seed
  controllers = %w(users posts settings photos)
  actions = %w(index new create edit update destroy)
  
  Timecop.freeze(Time.now)
  200.of do
    Timecop.travel(rand(10))
    req = Request.new(:controller_name => controllers.pick,
                      :action_name => actions.pick,
                      :response_time => 5.of{ 60 + rand(40)}.sum)
  end
end