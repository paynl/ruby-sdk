module Paynl
  module Api
    class GetPayServerIps < Api
      @@version = 1;

      def doRequest ()
        return super('validate/getPayServerIps',@@version)
      end

      def processResult(result)
        # Nothing to do here
        return result
      end
    end
  end
end