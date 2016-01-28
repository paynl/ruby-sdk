[![Build Status](https://travis-ci.org/paynl/ruby-sdk.svg?branch=master)](https://travis-ci.org/paynl/ruby-sdk)
# Pay.nl SDK in Ruby

---

- [Installation](#installation)
- [Requirements](#requirements)
- [Quick start and examples](#quick-start-and-examples)

---

This SDK is available as Ruby gem. 

With this SDK you will be able to start transactions and retrieve transactions with their status for the Pay.nl payment service provider.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paynl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paynl

## Requirements
This gem requires Ruby 1.9.2+.
We have tested this gem with Ruby 2.2.1.

## Usage

Loading the gem (after installation):
```ruby
require 'paynl'
```

Setting the configuration:
```ruby
require 'paynl'

Paynl::Config::setApiToken('e41f83b246b706291ea9ad798ccfd9f0fee5e0ab')
Paynl::Config::setServiceId('SL-3490-4320')
```

Getting a list of available payment methods for your site:
```ruby
require 'paynl'

Paynl::Config::setApiToken('e41f83b246b706291ea9ad798ccfd9f0fee5e0ab')
Paynl::Config::setServiceId('SL-3490-4320')
api = Paynl::Paymentmethods.new
options = Hash.new
puts api.getList(options)
```

Starting a transaction:
```ruby
require 'paynl'

Paynl::Config::setApiToken('e41f83b246b706291ea9ad798ccfd9f0fee5e0ab')
Paynl::Config::setServiceId('SL-3490-4320')

data = Paynl::Transaction.new
options = Hash.new
# Required values
options.store('amount', 6.21)
options.store('returnUrl', 'http://some.url.for.your.system.example.org/visitor-return-after-payment')
options.store('ipaddress', '127.0.0.1')


# Optional values
options.store('paymentMethod', 10)
options.store('description', 'demo payment')
options.store('testMode', true)
options.store('extra1', 'ext1')
options.store('extra2', 'ext2')
options.store('extra3', 'ext3')
options.store('language','EN')

# First product
products = Hash.new
product = Hash.new
product.store('id', '234567')
product.store('price', 1.21)
product.store('tax', 0.21)
product.store('name', 'Testproduct voor de demo tour')
product.store('qty', 1)
products.store(products.length + 1, product)

# Second product
product = Hash.new
product.store('id', '2')
product.store('price', 5.00)
product.store('tax', 0.87)
product.store('name', 'Testproduct 2 voor de demo tour')
product.store('qty', 1)
products.store(products.length + 1, product)
options.store('products', products)

# Enduser data
enduser = Hash.new
enduser.store('initials', 'T')
enduser.store('lastName', 'Test')
enduser.store('gender', 'M')
enduser.store('dob', '14-05-1999')
enduser.store('phoneNumber', '0612345678')
enduser.store('emailAddress', 'test@example.org')
options.store('enduser', enduser)

# Address data
address = Hash.new
address.store('streetName', 'Test')
address.store('houseNumber', '10')
address.store('zipCode', '1234AB')
address.store('city', 'Test')
address.store('country', 'NL')
options.store('address', address)

invoiceAddress = Hash.new
invoiceAddress.store('initials', 'IT')
invoiceAddress.store('lastName', 'ITTest')
invoiceAddress.store('streetName', 'ITest')
invoiceAddress.store('houseNumber', '15')
invoiceAddress.store('zipCode', '1234CC')
invoiceAddress.store('city', 'TTest')
invoiceAddress.store('country', 'NL')
options.store('invoiceAddress', invoiceAddress)

result = data.start(options)

# Store the transaction ID which is in
puts result['transaction']['transactionId']

# Redirect the user to the URL
puts result['transaction']['paymentURL']
```

To determine if a transaction has been paid, you can use:
```ruby
require 'paynl'

Paynl::Config::setApiToken('e41f83b246b706291ea9ad798ccfd9f0fee5e0ab')
Paynl::Config::setServiceId('SL-3490-4320')

data = Paynl::Transaction.new
result = data.getTransaction(transactionId)
if Paynl::Helper::transactionIsPaid(result) or Paynl::Helper::transactionIsPending(result)
    # redirect user to thank you page
else
    # it has not been paid yet, so redirect user back to checkout
end
```

When implementing the exchange script (where you should process the order in your backend):
```ruby
require 'paynl'

Paynl::Config::setApiToken('e41f83b246b706291ea9ad798ccfd9f0fee5e0ab')
Paynl::Config::setServiceId('SL-3490-4320')

data = Paynl::Transaction.new
result = data.getTransaction(transactionId)
if Paynl::Helper::transactionIsPaid(result)
    # Process the payment
elsif Paynl::Helper::transactionIsCanceled(result)
    # Payment canceled, restock items
end

puts 'TRUE| ' 
# Optionally you can send a message after TRUE|, you can view these messages in the logs.
# https://admin.pay.nl/logs/payment_state
puts 'Paid: ' + Paynl::Helper::transactionIsPaid(result).to_s
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paynl/sdk-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
