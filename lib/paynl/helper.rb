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

    def self.nearest(number, numbers)
      if (numbers.is_a? Hash)
        # numbers is a, I suppose, hash, not an array, for this piece of magick I need an array
        numbers = numbers.to_a
      end
      # And this is the reason why Ruby is more interesting than PHP, we can do this in 1 line of code
      return numbers.min_by{ |x| (x.first.to_f - number).abs }
    end

    def self.calculateTaxClass(amountInclTax, taxAmount)
      # Setup basic taxClasses (like in the PHP SDK)
      taxClasses = Hash.new
      taxClasses.store(0, 'N')
      taxClasses.store(6, 'L')
      taxClasses.store(21, 'H')

      if (taxAmount == 0 || amountInclTax == 0)
        return taxClasses[0]
      end

      amountExclTax = amountInclTax - taxAmount
      taxRate = (taxAmount / amountExclTax) * 100
      nearestTaxRate = self.nearest(taxRate, taxClasses)
      return nearestTaxRate
    end

    def self.transactionIsPaid(transaction)
      unless transaction.is_a? Hash
        raise('Please give me the output of the Paynl::Transaction::getTransaction function')
      end

      if transaction['paymentDetails']['stateName'] == 'PAID'
        return true
      end

      return false
    end

    def self.transactionIsPending(transaction)
      unless transaction.is_a? Hash
        raise('Please give me the output of the Paynl::Transaction::getTransaction function')
      end

      if transaction['paymentDetails']['stateName'] == 'PENDING'
        return true
      end

      return false
    end

    def self.transactionIsCanceled(transaction)
      unless transaction.is_a? Hash
        raise('Please give me the output of the Paynl::Transaction::getTransaction function')
      end

      if transaction['paymentDetails']['stateName'] == 'CANCEL'
        return true
      end

      return false
    end

  end
end
