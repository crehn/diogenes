#!/usr/bin/ruby

require "net/http"
require "uri"
require 'json'

require_relative 'config.rb'

class PantaRheiGateway

	def send(request)
		puts `#{request.line}`
	end

	def query(query)
		puts `#{HTTPIE} GET #{ENDPOINT}/sips 'q==#{query}'`
	end

	def read(guid)
		http = Net::HTTP.new(HOST, PORT)
		get = Net::HTTP::Get.new("/rest/sips/#{guid}")
		get['accept'] = 'application/json'
		response = http.request(get)
		response.value # throws error if not 2xx
		return JSON.parse(response.body, symbolize_names: true)
	end

	def delete(guid)
		puts `#{HTTPIE} DELETE #{ENDPOINT}/sips/#{guid}`
	end
end
