module Paynl
  class Helper
    def requireApiToken
      apiToken = Paynl::Config::getApiToken

      # Hmm, porting PHP to Ruby is crap if you want to keep the structure
      if apiToken = nil?
        raise Paynl::Error::Required::ApiTokenError, 'Api token is required'
      end
    end

    def requireServiceId
      serviceId = Paynl::Config::getServiceId

      if serviceId = nil?
        raise Paynl::Error::Required::ServiceIdError, 'No Service Id is set'
      end

    end
  end
end
