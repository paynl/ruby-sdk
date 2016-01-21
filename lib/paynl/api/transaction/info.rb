module Paynl
  module Api
    class TransactionInfo < Api

      @transactionId = '';

      def getData
        Paynl::Helper::requireApiToken
        @@data['token'] = Paynl::Config::getApiToken

        if (@transactionId.nil?)
          raise('TransactionId not set, please use setTransactionId first.')
        end

        @@data['transactionId'] = @transactionId

        return super;
      end

      def setTransactionId(transactionId)
        @transactionId = transactionId
      end

      def doRequest
        return super('transaction/info', nil)
      end
    end
  end
end
