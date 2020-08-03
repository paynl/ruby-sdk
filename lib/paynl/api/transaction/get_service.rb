module Paynl
  module Api
    class GetService < Api

      def getData
        Paynl::Helper::requireServiceId
        @@data['serviceId'] = Paynl::Config::getServiceId

        Paynl::Helper::requireApiToken
        @@data['token'] = Paynl::Config::getApiToken

        return super;
      end

      def doRequest
        # TODO: add caching to this
        return super('transaction/getService', 16)
      end
    end
  end
end
