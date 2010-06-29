require 'rubygems'
require 'riot'
require 'chronos'
require 'timecop'

Chronos.riak.port = 8091

CONTROLLERS = %w(users posts settings photos)
ACTIONS = %w(index new create edit update destroy)

class Request
  include Chronos::Document
  
  resolution :minute
  
  tag :controller_name
  tag :action_name
  
  def self.make
    new(:controller_name => CONTROLLERS.pick, 
        :action_name => ACTIONS.pick, 
        :request_time => 5.of{ 60 + rand(40)}.sum)
  end
  
  def self.gen
    make.save
  end
end


