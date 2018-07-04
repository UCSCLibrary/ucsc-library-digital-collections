module Qa::Authorities
  module WebServiceBase
    attr_accessor :raw_response

    # Override to use HTTParty instead of Faraday
    # Faraday was mishandling queries parameters for LOC
    def json url
      return super(url) unless url.include? "loc.gov"
      JSON.parse(HTTParty.get(url).body)
    end

    def get_json(url)
      json(url)
    end

  end
end
