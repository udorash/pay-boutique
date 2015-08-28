module PayBoutique
  class Config
    include ActiveSupport::Configurable

    config_accessor :user_id, :password, :merchant_id, :success_url, :failure_url, :postback_url, :live, :site_address

    def initialize(options = {})
      options.each do |key, value|
        config.send("#{key}=", value)
      end
    end
  end
end
