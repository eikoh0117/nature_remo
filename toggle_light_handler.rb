require 'faraday'
require 'dotenv/load'
require 'aws-record'

def request
  client = Faraday.new url: ENV['BASE_URL']
  client.headers['Authorization'] = "Bearer #{ENV['TOKEN']}"
  params = { button: "next" }
  client.post do |req|
    req.url "/1/appliances/#{ENV['APPLIANCE_ID']}/light"
    req.body = params
  end
end

def turn_on
  1.times { request() }
end

def turn_off
  2.times { request() }
end

def lambda_handler
  turn_on()
end

lambda_handler()