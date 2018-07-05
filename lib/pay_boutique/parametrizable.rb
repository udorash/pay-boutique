module PayBoutique
  module Parametrizable
    def initialize(params)
      @params = params

      filter_params
      verify_params

      __setobj__ @params
    end

    Config::CONFIGS.each do |attribute|
      define_method attribute do
        instance_variable_get("@#{attribute}") || PayBoutique.configuration.send(attribute)
      end
    end

    def postback_url
      @postback_url || PayBoutique.configuration.send("#{@params.payment_method}_postback_url") ||
        PayBoutique.configuration.postback_url
    end

    private

    def time
      @time ||= Time.now.utc.strftime('%Y%m%dT%H%M%S+00')
    end

    def verify_params
      missed_params = self.class.required_params - (existing_params & self.class.required_params)
      return unless missed_params.any?

      missed_params = missed_params.map(&:inspect).join(', ')
      raise ArgumentError, "wrong arguments, missed: #{missed_params}"
    end

    def filter_params
      @params.to_h.each_key do |field|
        @params.delete_field field if !self.class.params.include?(field) && @params[field]
      end
    end

    def existing_params
      @existing_params ||= @params.to_h.keys.compact + PayBoutique.configuration.config.compact.keys
    end
  end
end
