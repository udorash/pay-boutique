module PayBoutique
  class Config
    include ActiveSupport::Configurable

    CONFIGS = %i[
      site_address buyer_currency merchant_currency password live credit_card_postback_url
      merchant_id success_url failure_url qiwi_postback_url user_id request_url postback_url
      yandex_money_postback_url
    ].freeze

    config_accessor(*CONFIGS)

    def initialize(**options)
      options.each do |key, value|
        config.send("#{key}=", value)
      end
    end
  end
end
