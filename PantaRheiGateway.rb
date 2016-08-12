#!/usr/bin/ruby

require_relative 'config.rb'

class PantaRheiGateway

	def send(request)
		puts `#{request.line}`
	end

	def query(query)
		puts `#{HTTPIE} GET #{ENDPOINT}/sips 'q==#{query}'`
	end

end
