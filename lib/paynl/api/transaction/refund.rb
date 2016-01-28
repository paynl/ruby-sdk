module Paynl
  module Api
    class TransactionRefund < Api
      @transactionId = ''
      @amount = ''
      @description = ''

      def setTransactionId(transactionId)
        if (transactionId.nil?)
          raise('TransactionId cannot be nil. Please set valid transactionId');
        end
        @transactionId = transactionId
      end

      def setAmount(amount)
        @amount = amount
      end

      def setDescription(description)
        @description = description
      end

      def getData
        Paynl::Helper::requireApiToken
        @@data['token'] = Paynl::Config::getApiToken

        if (@transactionId.nil?)
          raise('TransactionId not set, please use setTransactionId first.')
        end

        unless (@amount.nil?)
          @@data['amount'] = @amount
        end

        @@data['transactionId'] = @transactionId

        return super;
      end

      def doRequest
        return super('transaction/refund', nil)
      end
    end
  end
end
