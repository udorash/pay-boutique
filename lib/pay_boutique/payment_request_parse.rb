module PayBoutique
  class PaymentRequestParse
    def initialize(str_xml)
      @xml = Nokogiri::XML(str_xml)
    end

    def redirect_url
      @xml.xpath("//Message//Body//RedirectURL").text
    end
  end
end
