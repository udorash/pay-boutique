module PayBoutique
  class PaymentCompletionParse
    def initialize(str_xml)
      @xml = Nokogiri::XML(str_xml)
      @order_id = @xml.xpath("//Message//Body//OrderID").text
      @amount = @xml.xpath("//Message//Body//AmountMerchantCurrency").text
    end

    def valid_payment?
      checksum = @xml.xpath("//Message//Header//Identity//Checksum").text
      time = @xml.xpath("//Message//Header//Time").text
      reference_id = @xml.xpath("//Message//Body//ReferenceID").text

      checksum == Signature.sign_params([time, reference_id])
    end

    def status
      @xml.xpath("//Message//Body//Status").text
    end

    def reference_id
      @xml.xpath("//Message//Body//ReferenceID").text
    end

    def order_id
      @order_id
    end

    def amount
      @amount
    end

    def provider
      'qiwi'
    end
  end
end
