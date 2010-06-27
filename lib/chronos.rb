require 'active_support/core_ext'
require 'riak/client'

$:.unshift File.dirname(__FILE__)

require 'chronos/document'
require 'chronos/extensions'
require 'chronos/resolution'

module Chronos
  extend self
  
  def riak
    @riak ||= Riak::Client.new
  end
  
  def riak=(client)
    @riak ||= Riak::Client.new
  end
end