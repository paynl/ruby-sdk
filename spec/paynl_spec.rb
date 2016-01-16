require 'spec_helper'

validServiceId = 'SL-3490-4320'
validApiToken = 'e41f83b246b706291ea9ad798ccfd9f0fee5e0ab'

describe Paynl do
  it 'has a version number' do
    expect(Paynl::VERSION).not_to be nil
  end

  it 'can retrieve all Pay.nl server IP\'s' do
    counter = 0
    Paynl::Config::setServiceId('');
    Paynl::Config::setApiToken('')
    data =  Paynl::Api::GetPayServerIps.new
    data.doRequest().each_with_index { |val, index| counter+=1 }
    expect(counter).to be > 10
  end

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
