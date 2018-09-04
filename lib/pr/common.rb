require 'pr/common/version'
require 'pr/common/engine'
require 'pr/common/configuration'
require 'pr/common/tokenable'
require 'pr/common/shopifyable'
require 'pr/common/token_authenticable'

module PR
  module Common
    def self.configure
      yield config
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.config=(config)
      @config = config
    end
  end
end
