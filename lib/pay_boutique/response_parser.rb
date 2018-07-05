module PayBoutique
  class ResponseParser
    attr_reader :order_id, :amount

    def initialize(str_xml)
      @xml = Nokogiri::XML(str_xml)
      @order_id = @xml.xpath('//Message//Body//OrderID').text
      @amount = @xml.xpath('//Message//Body//AmountMerchantCurrency').text
    end

    def valid?
      checksum = @xml.xpath('//Message//Header//Identity//Checksum').text
      time = @xml.xpath('//Message//Header//Time').text
      reference_id = @xml.xpath('//Message//Body//ReferenceID').text

      checksum == Signature.create(time, reference_id)
    end

    def status
      @xml.xpath('//Message//Body//Status').text
    end

    def reference_id
      @xml.xpath('//Message//Body//ReferenceID').text
    end

    def captured?
      status == 'captured'
    end

    def payment_method
      @xml.xpath('//Message//Body//PaymentMethod').text.snakecase.to_sym
    end
  end
end
