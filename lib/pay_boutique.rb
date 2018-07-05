require 'yaml'
require 'active_support'

require 'pay_boutique/config'
require 'pay_boutique/request'
require 'pay_boutique/parametrizable'
require 'pay_boutique/payment_details'
require 'pay_boutique/response_parser'
require 'pay_boutique/payment_gateway'
require 'pay_boutique/request_parser'
require 'pay_boutique/signature'
require 'pay_boutique/version'

module PayBoutique
  def configuration
    @configuration ||= Config.new
  end

  def config
    config = configuration
    yield(config)
  end

  module_function :configuration, :config
end
