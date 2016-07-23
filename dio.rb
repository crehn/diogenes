#!/usr/bin/ruby

require 'securerandom'

MODES = ['c','r','u','d'];
HTTPIE = 'http -v --json --pretty=all'
ENDPOINT = 'localhost:8080/rest'

def read_mode
	if MODES.include? ARGV[0] then
		return ARGV.shift
	else
		return 'r'
	end
end

def create_sip
	guid = SecureRandom.uuid
	puts `#{HTTPIE} PUT #{ENDPOINT}/sips/#{guid} guid=#{guid} #{ARGV.join ' '}`
end

def read_sips
	while ARGV.length > 0
		puts `#{HTTPIE} GET #{ENDPOINT}/sips/#{ARGV.shift}`
	end
end

def update_sip

end

def delelte_sip

end

case read_mode
when 'c' then create_sip
when 'r' then read_sips
when 'u' then update_sip
when 'd' then delete_sip
else raise "unknown mode"
end

