#!/usr/bin/ruby

require 'securerandom'

require_relative 'config.rb'

class CreateSipRequest
	public
	def title(title)
		@title = title
		return self
	end

	public
	def sourceUri(sourceUri)
		@sourceUri = sourceUri
		return self
	end

	public
	def tags(tags)
		@tags = tags
		return self
	end

	public
	def text(text)
		@text = text.nil? ? nil : escape(text)
		return self
	end

	private
	def escape(text)
		return text.gsub /'/, %q{\\\\'}
	end

	public
	def line
		guid = SecureRandom.uuid
		result = "#{HTTPIE} PUT #{ENDPOINT}/sips/#{guid} "
		result += "title=#{@title} " unless @title.nil?
		result += "sourceUri=#{@sourceUri} " unless @sourceUri.nil?
		result += "text='#{@text}' " unless @text.nil?
		result += "tags:='#{@tags}' " unless @tags.nil? or @tags.empty?
		return result.strip
	end
end

