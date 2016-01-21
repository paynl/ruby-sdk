require 'spec_helper'

validServiceId = 'SL-3490-4320'
validApiToken = 'e41f83b246b706291ea9ad798ccfd9f0fee5e0ab'

describe Paynl do
  it 'has a version number' do
    expect(Paynl::VERSION).not_to be nil
  end
end

describe Paynl::Api do

  it 'can retrieve all Pay.nl server IP\'s' do
    counter = 0
    Paynl::Config::setServiceId('');
    Paynl::Config::setApiToken('')
    data =  Paynl::Api::GetPayServerIps.new
    data.doRequest().each_with_index { |val, index| counter+=1 }
    expect(counter).to be > 10
  end
end

describe Paynl::Api::IsPayServerIp do
  it 'can determine that 127.0.0.1 is not a valid Pay.nl server ip' do
    data = Paynl::Api::IsPayServerIp.new
    data.setIpAddress('127.0.0.1');
    expect(data.doRequest()).to be false
  end

  it 'can determine that 37.46.137.129 is a valid Pay.nl server ip' do
    data = Paynl::Api::IsPayServerIp.new
    data.setIpAddress('37.46.137.129');
    expect(data.doRequest()).to be true
  end
end

describe Paynl::Api::GetService do
  it 'can detect a missing Service ID when getting payment options' do
    expect {
      Paynl::Config::setServiceId('');
      Paynl::Config::setApiToken(validApiToken)
      data = Paynl::Api::GetService.new
      puts data.doRequest
    }.to raise_error('No Service Id is set')
  end

  it 'can detect a missing ApiToken when getting payment options' do
    expect {
      Paynl::Config::setServiceId(validServiceId);
      Paynl::Config::setApiToken('')
      data = Paynl::Api::GetService.new
      puts data.doRequest
    }.to raise_error('Api token is required')
  end

  it 'can fetch payment methods for country NL' do
    counter = 0
    Paynl::Config::setApiToken(validApiToken)
    Paynl::Config::setServiceId(validServiceId)
    data = Paynl::Paymentmethods.new
    options = Hash.new()
    options.store('country','NL')
    data.getList(options).each_with_index { |val, index| counter+=1 }
    expect(counter).to be > 2
  end
end

describe Paynl::Transaction do
  it 'can start a transaction with the Demonstration version over the API' do
    Paynl::Config::setApiToken('e41f83b246b706291ea9ad798ccfd9f0fee5e0ab')
    Paynl::Config::setServiceId('SL-3490-4320')
    data = Paynl::Transaction.new
    options = Hash.new
    options.store('amount', 1.21)
    options.store('returnUrl', 'https://pay.nl')
    options.store('ipaddress', '127.0.0.1')
    options.store('testMode', false)
    products = Hash.new
    product = Hash.new
    product.store('id', '234567u')
    product.store('price', 1.21)
    product.store('tax', 0.21)
    product.store('name', 'Testproduct voor de demo tour')
    product.store('qty', 1)
    products.store(products.length + 1, product)
    options.store('products', products)
    result = data.start(options)
    expect(result['request']['result']).to eq('1')
  end

  it 'can detect if the amount is not set during api call' do
    expect {
      Paynl::Config::setApiToken('e41f83b246b706291ea9ad798ccfd9f0fee5e0ab')
      Paynl::Config::setServiceId('SL-3490-4320')
      data = Paynl::Transaction.new
      options = Hash.new
      # options.store('amount', 1.21)
      options.store('returnUrl', 'https://pay.nl')
      options.store('ipaddress', '127.0.0.1')
      options.store('testMode', false)
      products = Hash.new
      product = Hash.new
      product.store('id', '234567u')
      product.store('price', 1.21)
      product.store('tax', 0.21)
      product.store('name', 'Testproduct voor de demo tour')
      product.store('qty', 1)
      products.store(products.length + 1, product)
      options.store('products', products)
      result = data.start(options)
      data.start(options)
    }.to raise_error('Amount has to be set and in cents')
  end

  it 'will fail if no ip address has been provided while creating the transaction' do
    expect {
      Paynl::Config::setApiToken('e41f83b246b706291ea9ad798ccfd9f0fee5e0ab')
      Paynl::Config::setServiceId('SL-3490-4320')
      data = Paynl::Transaction.new
      options = Hash.new
      options.store('amount', 1.21)
      options.store('returnUrl', 'https://pay.nl')
      # options.store('ipaddress', '127.0.0.1')
      options.store('testMode', false)
      products = Hash.new
      product = Hash.new
      product.store('id', '234567u')
      product.store('price', 1.21)
      product.store('tax', 0.21)
      product.store('name', 'Testproduct voor de demo tour')
      product.store('qty', 1)
      products.store(products.length + 1, product)
      options.store('products', products)
      result = data.start(options)
      data.start(options)
    }.to raise_error('IP addresses are required for payments')
  end

end
