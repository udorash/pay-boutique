module PayBoutique
  class RequestParser
    def initialize(str_xml)
      @xml = Nokogiri::XML(str_xml)
    end

    def amount_merchant_currency
      @xml.xpath('//Message//Body//AmountMerchantCurrency').text
    end

    def order_id
      @xml.xpath('//Message//Body//OrderID').text
    end

    def redirect_url
      @xml.xpath('//Message//Body//RedirectURL').text
    end

    def card_mask
      @xml.xpath('//Message//Body//Card//CardMask').text
    end
  end
end
