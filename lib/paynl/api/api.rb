module Paynl
  module Api
    class Api
      @version = 1
      @@data = Hash.new

      @apiTokenRequired = false
      @serviceIdRequired = false

      def isApiTokenRequired
        return @apiTokenRequired
      end


      def isServiceIdRequired
        return @serviceIdRequired
      end

      def getData
        if isApiTokenRequired
          Paynl::Helper::requireApiToken

          @@data['token'] = Paynl::Config::getApiToken
        end

        if isServiceIdRequired
          Paynl::Helper::requireServiceId

          @@data['serviceId'] = Paynl::Config::getServiceId
        end

        return @@data
      end

      def processResult(result)
        if result['request']['result'] != '1' and result['request']['result'] != 'TRUE'
          raise result['request']['errorId'] + ' - ' + result['request']['errorMessage']
        end

        return result
      end

      def doRequest(endpoint, version = nil)

        data = getData
        uri = Paynl::Config::getApiUrl(endpoint, version)
        # puts uri
        # puts data
        # Code to actually do the CURL request
        response = Typhoeus::Request.post(
            uri,
            params: data,
            :headers => { 'User-Agent' => 'Ruby SDK ' + VERSION }
        )

        # if response.code != 200
        #   raise 'API error'
        # end

        # puts response.code    # http status code
        # puts response.time    # time in seconds the request took
        # puts response.headers # the http headers
        # puts response.headers_hash # http headers put into a hash
        # puts response.body    # the response body

        output = processResult(JSON.parse(response.body))
        return output

      end
    end
  end
end
