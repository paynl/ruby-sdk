module Paynl
  class Config
    @@apiToken=''
    @@serviceId=''
    @@apiBase='https://rest-api.pay.nl'
    @@apiVersion=5

    # getApiToken - Retrieves Pay.nl api token
    def self.getApiToken
      return @@apiToken
    end

    # setApiToken - Sets Pay.nl api token
    def self.setApiToken(apiToken)
      @@apiToken = apiToken
    end

    # getServiceId - Retrieves Pay.nl Service Id
    def self.getServiceId
      return @@serviceId
    end

    # setServiceId - Set the Pay.nl Service Id
    def self.setServiceId(serviceId)
      @@serviceId = serviceId
    end

    # getApiVersion - Retrieves Pay.nl Api version
    def self.getApiVersion
      return @@apiVersion
    end

    # setApiVersion - Set the Pay.nl Api version
    def self.setApiVersion(apiVersion)
      @@apiVersion = apiVersion
    end

    # getApiUrl - Get constructed API Url for the given endpoint
    def self.getApiUrl(endpoint, version = nil)
      unless !version.nil?
        version = @@apiVersion
      end

      return @@apiBase + '/v' + version.to_s + '/' + endpoint + '/json'
    end
  end
end
