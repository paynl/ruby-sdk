module Paynl
  class Helper
    def self.requireApiToken
      apiToken = Paynl::Config::getApiToken

      # Hmm, porting PHP to Ruby is crap if you want to keep the structure
      if apiToken == nil? or apiToken == ''
        raise Paynl::Error::Required::ApiTokenError, 'Api token is required'
      end
    end

    def self.requireServiceId
      serviceId = Paynl::Config::getServiceId
      if serviceId == nil? or serviceId == ''
        raise Paynl::Error::Required::ServiceIdError, 'No Service Id is set'
      end

    end
  end
end
