require 'faraday'
require 'dotenv/load'
require 'aws-record'

class NatureRemoRecords
  include Aws::Record
  string_attr :role, hash_key: true
  string_attr :power
end

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
  response = request()
  response_body = JSON.parse(response.body)
  role = "toggle_light"
  item = find_item(role)
  item.power = "on"
  item.save
end

def turn_off
  2.times do
    request()
  end
  item = find_item("toggle_light")
  item.power = "off"
  item.save
end

def find_item(role)
  NatureRemoRecords.find(role: role)
end

def lambda_handler(event:, context:)
  item = find_item("toggle_light")
  if item.power === "on"
    turn_off()
  else
    turn_on()
  end
end
