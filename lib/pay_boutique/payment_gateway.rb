require 'httparty'

module PayBoutique
  class PaymentGateway
    include HTTParty
    headers ({ "Content-Type" => 'application/x-www-form-urlencoded; charset=UTF-8'})
    debug_output $stdout

    class Params < SimpleDelegator

      REQUIED_PARAMS = %w(user_id buyer_currency merchant_currency amount_merchant_currency merchant_id order_id expiration_time description merchant_reference label product_name site_address payment_method first_name middle_name last_name address city country account_id success_url failure_url postback_url)

      def initialize(params)
        @params = params

        filter_params

        __setobj__ @params
      end

      def to_xml
        @xml = Nokogiri::XML::Builder.new do |root|
          root.Message(version: '0.5') do |xml|
            xml.Header do |header|
              header.Identity do |identity|
                identity.UserID user_id
                identity.Signature PayBoutique::Signature.sign_params(time)
              end
              header.Time time
            end

            xml.Body(type: 'GetInvoice', live: PayBoutique.configuration.live) do |body|
              body.Order(paymentMethod: payment_method, buyerCurrency: buyer_currency) do |order|
                order.MerchantID merchant_id
                order.OrderID order_id
                order.AmountMerchantCurrency amount_merchant_currency
                order.MerchantCurrency merchant_currency
                # order.ExpirationTime expiration_time
                # order.Label label
                order.SiteAddress site_address
                # order.Description description
                order.SuccessURL success_url
                order.FailureURL failure_url
                unless PayBoutique.configuration.live
                  order.PostbackUrl postback_url
                end
                order.Buyer do |buyer|
                  # buyer.FirstName first_name
                  # buyer.MiddleName middle_name
                  # buyer.LastName last_name
                  # buyer.Address address
                  # buyer.City city
                  # buyer.Country country
                  buyer.AccountID account_id
                end
              end
            end
          end
        end
        @xml
      end

      private

      def site_address
        PayBoutique.configuration.site_address
      end

      def buyer_currency
        'RUB'
      end

      def merchant_currency
        'USD'
      end

      def payment_method
        'Qiwi'
      end

      def header
        Nokogiri::XML::Builder.new do |xml|
          xml.Header do |header|
            header.Identity do |identity|
              identity.UserID user_id
              identity.Signature PayBoutique::Signature.sign_params(time)
            end
            header.Time time
          end
        end
      end

      def body
        Nokogiri::XML::Builder.new do |xml|
          xml.Body(type: 'GetInvoice', live: PayBoutique.configuration.live) do |body|
            body.Order(paymentMethod: payment_method, buyer_currency: buyer_currency) do |order|
              order.MerchantID merchant_id
              order.OrderID order_id
              order.AmountMerchantCurrency amount_merchant_currency
              order.MerchantCurrency merchant_currency
              order.ExpirationTime expiration_time
              order.Label label
              order.SiteAddress site_address
              order.Description description
              order.SuccessURL success_url
              order.FailureURL failure_url
              order.PostbackUrl postback_url
              order.Buyer buyer
            end
          end
        end
      end

      def buyer
        Nokogiri::XML::Builder.new do |buyer|
          buyer.FirstName first_name
          buyer.MiddleName middle_name
          buyer.LastName last_name
          buyer.Address address
          buyer.City city
          buyer.Country country
          buyer.AccountID account_id
        end
      end

      def time
        Time.now.utc.strftime('%Y%m%dT%H%M%S+00')
      end

      def password
        PayBoutique.configuration.password
      end

      def user_id
        PayBoutique.configuration.user_id
      end

      def filter_params
        @params.select! { |k, v| REQUIED_PARAMS.include?(k) && v }
      end

      def merchant_id
        PayBoutique.configuration.merchant_id
      end

      def success_url
        PayBoutique.configuration.success_url
      end

      def failure_url
        PayBoutique.configuration.failure_url
      end

      def postback_url
        PayBoutique.configuration.postback_url
      end
    end

    def initialize(params={})
      @params = Params.new(OpenStruct.new(params))
    end

    def get_url
      response = self.class.post('https://merchant.payb.lv/xml_service', body: {xml:@params.to_xml.doc.root.to_xml}.to_params)
      PaymentRequestParse.new(response).redirect_url
    end
  end
end
