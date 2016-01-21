module Paynl
  class Transaction
    def start(options)
      enduser = Hash.new

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

      unless (options['extra1']).nil?
        api.setExtra1(options['extra1'])
      end

      unless (options['extra2'].nil?)
        api.setExtra2(options['extra2'])
      end

      unless (options['extra3'].nil?)
        api.setExtra3(options['extra3'])
      end

      unless (options['products'].nil?)
        options['products'].each_with_index {
            |product, index|
          taxClass = Paynl::Helper::calculateTaxClass(product[1]['price'], product[1]['tax'])
          api.addProduct(product[1]['id'], product[1]['name'], (product[1]['price'].round * 100), product[1]['qty'], taxClass)
        }
      end

      unless (options['enduser'].nil?)
        enduser = options['enduser'].to_hash
      end

      unless (options['language'].nil?)
        enduser['language'] = options['language']
      end

      unless (options['address'].nil?)
        address = Hash.new
        unless (options['address']['streetName'].nil?)
          address.store('streetName', options['address']['streetName'])
        end
        unless (options['address']['houseNumber'].nil?)
          address.store('houseNumber', options['address']['houseNumber'])
        end
        unless (options['address']['zipCode'].nil?)
          address.store('zipCode', options['address']['zipCode'])
        end
        unless (options['address']['city'].nil?)
          address.store('city', options['address']['city'])
        end
        unless (options['address']['country'].nil?)
          address.store('country', options['address']['country'])
        end
        enduser.store('address', address)
      end

      unless (options['invoiceAddress'].nil?)
        invoiceAddress = Hash.new

        unless (options['invoiceAddress']['initials'].nil?)
          invoiceAddress.store('initials', options['invoiceAddress']['initials'])
        end
        unless (options['invoiceAddress']['lastName'].nil?)
          invoiceAddress.store('lastName', options['invoiceAddress']['lastName'])
        end

        unless (options['invoiceAddress']['streetName'].nil?)
          invoiceAddress.store('streetName', options['invoiceAddress']['streetName'])
        end
        unless (options['invoiceAddress']['houseNumber'].nil?)
          invoiceAddress.store('houseNumber', options['invoiceAddress']['houseNumber'])
        end
        unless (options['invoiceAddress']['zipCode'].nil?)
          invoiceAddress.store('zipCode', options['invoiceAddress']['zipCode'])
        end
        unless (options['invoiceAddress']['city'].nil?)
          invoiceAddress.store('city', options['invoiceAddress']['city'])
        end
        unless (options['invoiceAddress']['country'].nil?)
          invoiceAddress.store('country', options['invoiceAddress']['country'])
        end
        enduser.store('invoiceAddress', invoiceAddress)
      end

      api.setEnduser(enduser)
      return api.doRequest
    end

    def get(transactionId)

    end

    def refund(transactionId, amount = nil, description = nil)

    end
  end
end
