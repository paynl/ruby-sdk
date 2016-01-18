module Paynl
  class Transaction
    def start(options)

      api = Paynl::Api::StartTransaction.new
      unless (options['amount'].nil?)
        api.setAmount(options['amount'].round(2) * 100)
      end

      unless (options['currency'].nil?)
        api.setCurrency(options['currency'])
      end

      unless (options['returnUrl'].nil?)
        api.setFinishUrl(options['returnUrl'])
      end

      unless (options['exchangeUrl'].nil?)
        api.setExchangeUrl(options['exchangeUrl'])
      end

      unless (options['paymentMethod'].nil?)
        api.setPaymentOptionId(options['paymentMethod'])
      end

      unless (options['bank'].nil?)
        api.setPaymentOptionSubId(options['bank'])
      end

      unless (options['description'].nil?)
        api.setDescription(options['description'])
      end

      unless (options['testMode'].nil?)
        if options['testMode'] == true or options['testMode'] == 'true'
          api.setTestMode(true)
        end
      end

      unless (options['ipaddress'].nil?)
        api.setIpAddress(options['ipaddress'])
      end

      puts api.doRequest

    end

    def get(transactionId)

    end

    def refund(transactionId, amount = nil, description = nil)

    end
  end
end
