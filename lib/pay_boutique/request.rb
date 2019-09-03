require 'httparty'

module PayBoutique
  class Request
    include HTTParty
    headers 'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8'
    # debug_output $stdout

    private

    def request_body
      { xml: @params.to_xml.doc.root.to_xml }.to_params
    end

    def request_url
      @params.request_url || PayBoutique.configuration.request_url
    end
  end
end
