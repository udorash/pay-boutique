require 'yaml'
require 'pay_boutique/config'
require 'pay_boutique/payment_completion_parse'
require 'pay_boutique/payment_gateway'
require 'pay_boutique/payment_request_parse'
require 'pay_boutique/signature'
require "pay_boutique/version"

module PayBoutique
    extend self

    def self.configuration
      @configuration ||= Config.new
    end

    def self.config
      config = configuration
      yield(config)
    end
end
