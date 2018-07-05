module PayBoutique
  class PaymentDetails < Request
    attr_accessor :order_id, :reference_id

    class Params < SimpleDelegator
      include Parametrizable
      BODY_TYPE = 'getStatus'.freeze
      IDS = %i[order_id reference_id].freeze
      VERSION = '0.5'.freeze

      def to_xml
        @xml = Nokogiri::XML::Builder.new do |root|
          root.Message(version: VERSION) do |xml|
            xml.Header do |header|
              header.Identity do |identity|
                identity.UserID user_id
                identity.Signature Signature.create(time)
              end
              header.Time time
            end

            xml.Body(type: BODY_TYPE) do |body|
              body.Order do |order|
                order.OrderID order_id if try(:order_id)
                order.ReferenceID reference_id if try(:reference_id)
              end
            end
          end
        end
        @xml
      end

      private

      def verify_params
        @missed_params = self.class.required_params - (existing_params & self.class.required_params)
        return if @missed_params.empty? || missed_only_one_id

        raise ArgumentError, "wrong arguments, missed: #{@missed_params.map(&:inspect).join(', ')}"
      end

      def missed_only_one_id
        @missed_params.size == 1 && IDS.include?(@missed_params.first)
      end

      class << self
        def required_params
          configs = Config::CONFIGS + IDS

          if PayBoutique.configuration.qiwi_postback_url || PayBoutique.configuration.credit_card_postback_url
            configs.delete(:postback_url)
          end

          configs
        end

        def params
          required_params
        end
      end
    end

    def self.retrieve(**args)
      response = new(args).call
      RequestParser.new(response)
    end

    def initialize(**params)
      @params = Params.new(OpenStruct.new(params))
    end

    def call
      self.class.post(request_url, body: request_body)
    end
  end
end
