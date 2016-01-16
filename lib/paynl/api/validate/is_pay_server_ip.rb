module Paynl
  module Api
    class IsPayServerIp < Api
      def getData
        if @@data['ipAddress'] == nil?
          raise Paynl::Error::RequiredError('ipAddress is required')
        end

        return @@data
      end

      def setIpAddress(ipAddress)
        @@data['ipAddress'] = ipAddress
      end

      def processResult(result)
        return !result['result'].to_i.zero?
      end

      def doRequest(endpoint = nil, version = nil)
        return super('validate/isPayServerIp', version)
      end
    end
  end
end
