require 'active_support/core_ext'
require 'riak/client'
require 'hashie'

$:.unshift File.dirname(__FILE__)

require 'timemaster/helpers'
require 'timemaster/extensions'
require 'timemaster/document'
require 'timemaster/resolution'

module Timemaster
  extend self
  
  def riak
    @riak ||= Riak::Client.new
  end
  
  def riak=(client)
    @riak ||= Riak::Client.new
  end
end