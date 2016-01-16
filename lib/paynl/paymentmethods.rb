module Paynl
  class Paymentmethods

    def filterCountry(paymentMethods, country)
      output = Hash.new
      paymentMethods.each do |key, paymentMethod|
        paymentMethod['countries'].each_with_index do |countryFromList, index|
            if countryFromList[1]['id'] == country or countryFromList[1]['id'] == 'ALL'
              output.store(output.length + 1, paymentMethod)
            end
          end
        end
      return output
    end

    def reorderOutput(input)
      paymentMethods = Hash.new
      input['countryOptionList'].each do |key, country|
        country['paymentOptionList'].each_with_index do |paymentOption, index|

          if !paymentMethods[paymentOption[1]['id']].nil?

            paymentMethods[paymentOption[1]['id']]['countries'].store(
                paymentMethods[paymentOption[1]['id']]['countries'].length + 1, country['id'])
          else
            banks = Hash.new
            unless paymentOption[1]['paymentOptionSubList'] != nil?
              paymentOption[1]['paymentOptionSubList'].each do |optionSub, index|
                bank = Hash.new
                bank['id'] = optionSub['id']
                bank['name'] = optionSub['name']
                bank['visibleName'] = optionSub['visibleName']
                banks[banks.length + 1] = bank
              end
            end

            paymentMethod = Hash.new
            paymentMethod['id'] = paymentOption[1]['id']
            paymentMethod['name'] = paymentOption[1]['name']
            paymentMethod['visibleName'] = paymentOption[1]['visibleName']
            countryList = Hash.new
            countryList.store(1,country)
            paymentMethod['countries'] = countryList
            paymentMethod['banks'] = banks
            paymentMethods.store(paymentOption[1]['id'],paymentMethod)
          end

        end
      end
      return paymentMethods
    end

    def getList(options)
      api = Paynl::Api::GetService.new
      result = api.doRequest()

      paymentMethods = self.reorderOutput(result)

      # TODO: this is not the best way to do this...
      if options.class.to_s == 'Hash'
        if !options['country'].nil?
          paymentMethods = self.filterCountry(paymentMethods, options['country'])
        end
      end

      return paymentMethods
    end
  end
end
