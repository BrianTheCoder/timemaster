require 'active_support/core_ext'
require 'riak/client'
require 'hashie'

$:.unshift File.dirname(__FILE__)

require 'chronos/helpers'
require 'chronos/extensions'
require 'chronos/document'
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