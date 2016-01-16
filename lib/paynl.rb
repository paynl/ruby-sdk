require 'yaml'
require 'typhoeus'
require 'json'
require 'paynl/api/api'

Dir[File.join(".", "**/*.rb")].each do |f|
  unless f == './paynl.rb'
    puts f
    require f
  end

end


module Paynl
  # Your code goes here...
end





# Retrieves server ip's
# data =  Paynl::Api::GetPayServerIps.new
# puts data.doRequest(nil, nil)

# Test valid IP
# data = Paynl::Api::IsPayServerIp.new
# data.setIpAddress('85.158.206.17');
# puts data.doRequest(nil, nil)

# Test invalid IP
# data = Paynl::Api::IsPayServerIp.new
# data.setIpAddress('127.0.0.1');
# puts data.doRequest(nil, nil)

