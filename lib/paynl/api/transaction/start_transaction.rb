module Paynl
  module Api
    class StartTransaction < Api
      @amount = nil
      @paymentOptionId = nil
      @paymentOptionSubId = nil
      @finishUrl = nil
      @currency = nil
      @exchangeUrl = nil
      @description = nil
      @enduser = Hash.new
      @extra1 = nil
      @extra2 = nil
      @extra3 = nil
      @testMode = false
      @promotorId = nil
      @info = nil
      @tool = nil
      @object = nil
      @domainId = nil
      @transferData = nil
      @ipaddress = nil
      @products = Hash.new

      def setIpAddress(ipAddress)
        @ipaddress = ipAddress;
      end
      def setPromotorId(promotorId)
        @promotorId = promotorId
      end
      def setCurrency(currency)
        @currency = currency
      end
      def setInfo(info)
        @info = info
      end
      def setTool(tool)
        @tool = tool;
      end
      def setObject(object)
        @object = object
      end
      def setTransferData(transferData)
        @transferData = transferData
      end

      def addProduct(id, description, price, quantity, vatPercentage)
        unless price.is_a? Numeric
          raise('Price has to be numerical')
        end

        unless quantity.is_a? Numeric
          raise('Quantity has to be numerical')
        end

        # copying code from PHP version... this has no use.
        quantity = quantity * 1

        # Description can only be 45 chars long
        description = description[0,45];

        product = Hash.new
        product.store('productId', id)
        product.store('description', description)
        product.store('price', price)
        product.store('quantity', quantity)
        product.store('vatCode', vatPercentage)

        @products.store(@products.length + 1,product);
      end

      def setEnduser(enduser)
        unless enduser.is_a? Hash
          raise('Please supply Hash with correct data')
        end
        @enduser = enduser
      end

      # Set amount (in cents) of the transaction
      def setAmount(amount)
        unless amount.is_a? Numeric
          raise('The amount has to be numeric (and in cents)')
        end

        @amount = amount
      end

      def setPaymentOptionId(paymentOptionId)
        unless paymentOptionId.is_a? Numeric
          raise('The paymentOptionId has to be numeric')
        end

        @paymentOptionId = paymentOptionId;
      end

      def setPaymentOptionSubId(paymentOptionSubId)
        unless paymentOptionSubId.is_a? Numeric
          raise('The paymentOptionSubId has to be numberic')
        end

        @paymentOptionSubId = paymentOptionSubId
      end

      # Set the url where the user will be redirected to after payment.
      def setFinishUrl(finishUrl)
        @finishUrl = finishUrl
      end

      # Set the communication url, the pay.nl server will call this url when the status of the transaction changes
      def setExchangeUrl(exchangeUrl)
        @exchangeUrl = exchangeUrl
      end

      def setTestMode(testMode = false)
        @testMode = testMode
      end

      def setExtra1(extra1)
        @extra1 = extra1
      end
      def setExtra2(extra2)
        @extra2 = extra2
      end
      def setExtra3(extra3)
        @extra3 = extra3
      end

      def setDomainId(domainId)
        @domainId = domainId
      end

      def setDescription(description)
        @description = description
      end

      def getData()
        Paynl::Helper::requireServiceId
        @@data['serviceId'] = Paynl::Config::getServiceId

        Paynl::Helper::requireApiToken
        @@data['token'] = Paynl::Config::getApiToken

        if @testMode.equal? true
          @@data['testMode'] = 1
        else
          @@data['testMode'] = 0
        end

        if @amount.nil?
          raise('Amount has to be set and in cents')
        else
          @@data['amount'] = @amount.round(0);
        end

        unless @paymentOptionId.nil?
          @@data['paymentOptionsId'] = @paymentOptionId
        end

        if @finishUrl.nil?
          raise('finishUrl is not set, which is required')
        else
          @@data['finishUrl'] = @finishUrl
        end

        # Crappy PHP associative array's are fcking my codestyle
        unless @@data['transaction'].is_a? Hash
          @@data['transaction'] = Hash.new
        end
        unless @@data['saleData'].is_a? Hash
          @@data['saleData'] = Hash.new
        end
        unless @@data['statsData'].is_a? Hash
          @@data['statsData'] = Hash.new
        end

        unless @exchangeUrl.nil?
          @@data['transaction'].store('orderExchangeUrl',@exchangeUrl)
        end

        unless @description.nil?
          @@data['transaction'].store('description', @description)
        end

        unless @currency.nil?
          @@data['transaction'].store('currency', @currency)
        end

        if @ipaddress.nil?
          #TODO: This is pure Ruby, no rails crap, so I can't abuse rails to get the IP
          raise("IP addresses are required for payments")
        else
          @@data['ipAddress'] = @ipaddress
        end

        unless @products.nil?
          @@data['saleData'].store('orderData',@products)
        end

        unless @enduser.nil?
          @@data['enduser'] = @enduser
        end

        unless @extra1.nil?
          @@data['statsData'].store('extra1',@extra1)
        end
        unless @extra2.nil?
          @@data['statsData'].store('extra2',@extra2)
        end
        unless @extra3.nil?
          @@data['statsData'].store('extra3',@extra3)
        end

        unless @promotorId.nil?
          @@data['statsData'].store('promotorId',@promotorId)
        end
        unless @info.nil?
          @@data['statsData'].store('info',@info)
        end
        unless @tool.nil?
          @@data['statsData'].store('tool',@tool)
        end
        unless @object.nil?
          @@data['statsData'].store('object',@object)
        end
        unless @domainId.nil?
          @@data['statsData'].store('domainId',@domainId)
        end
        unless @transferData.nil?
          @@data['statsData'].store('transferData',@transferData)
        end

        return super
      end

      def doRequest()
        return super('transaction/start', 5)
      end

    end
  end
end
