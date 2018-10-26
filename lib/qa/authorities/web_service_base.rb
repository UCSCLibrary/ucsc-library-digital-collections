module Qa::Authorities
  module WebServiceBase
    attr_accessor :raw_response

    # Override to use HTTParty instead of Faraday
    # Faraday was mishandling queries parameters for LOC
    def json url
#      if url.include? "loc.gov"
        response = HTTParty.get(url)
 #     else
  #      response Faraday.get(url) { |req| req.headers['Accept'] = 'application/json' }
#      end
      JSON.parse(response.body)
    end

    def get_json(url)
      json(url)
    end

  end
end
