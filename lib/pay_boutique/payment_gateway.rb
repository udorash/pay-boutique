module PayBoutique
  class PaymentGateway < Request
    LOG_FORMAT = :curl

    class Params < SimpleDelegator
      include Parametrizable

      BODY_TYPE = 'GetInvoice'.freeze
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

            xml.Body(type: BODY_TYPE, live: PayBoutique.configuration.live) do |body|
              body.Order(paymentMethod: payment_method_camelize, buyerCurrency: buyer_currency) do |order|
                order.MerchantID merchant_id
                order.OrderID order_id
                order.AmountMerchantCurrency amount_merchant_currency
                order.MerchantCurrency merchant_currency
                order.ExpirationTime expiration_time if try(:expiration_time)
                order.Label label if try(:label)
                order.SiteAddress site_address
                order.Description description if try(:description)
                order.SuccessURL success_url if try(:success_url)
                order.FailureURL failure_url if try(:failure_url)
                order.PostbackUrl postback_url
                order.Param3 param3 if try(:param3)
                order.Buyer do |buyer|
                  buyer.FirstName first_name if try(:first_name)
                  buyer.MiddleName middle_name if try(:middle_name)
                  buyer.LastName last_name if try(:last_name)
                  buyer.Address address if try(:address)
                  buyer.City city if try(:city)
                  buyer.Country country if try(:country)
                  buyer.AccountID account_id if try(:account_id)
                end
              end
            end
          end
        end
        @xml
      end

      private

      def payment_method_camelize
        payment_method.to_s.camelize
      end

      class << self
        def required_params
          configs = Config::CONFIGS + %i[payment_method order_id amount_merchant_currency]

          if PayBoutique.configuration.qiwi_postback_url || PayBoutique.configuration.credit_card_postback_url
            configs.delete(:postback_url)
          end

          configs
        end

        def params
          %i[
            user_id buyer_currency merchant_currency amount_merchant_currency
            merchant_id order_id expiration_time description merchant_reference
            label product_name site_address payment_method first_name middle_name
            last_name address city country account_id success_url failure_url
            credit_card_postback_url qiwi_postback_url param3
            yandex_money_postback_url
          ]
        end
      end
    end

    def initialize(**params)
      @params = Params.new(OpenStruct.new(params))
    end

    def url
      response = self.class.post(request_url, body: request_body)
      log_response(response)
      RequestParser.new(response).redirect_url
    end

    def log_response(response)
      log = ::HTTParty::Logger.build(
        PayBoutique.configuration.logger,
        PayBoutique.configuration.log_level,
        LOG_FORMAT
      )
      log.format(response.request, response.response)
    end
  end
end
