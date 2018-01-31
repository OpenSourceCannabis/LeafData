require 'httparty'
require 'LeafData/constants'
require 'LeafData/errors'
require 'LeafData/configuration'
require 'LeafData/client'
require "LeafData/version"

module LeafData
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    yield configuration
  end
end
