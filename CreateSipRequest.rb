#!/usr/bin/ruby

require 'securerandom'

require_relative 'config.rb'

class SipRequest
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
    def notes(notes)
        @notes = notes.nil? ? nil : escape(notes)
        return self
    end

    public
    def originTimestamp(originTimestamp)
        @originTimestamp = originTimestamp
        return self
    end

    public
    def due(due)
        @due = due
        return self
    end

    public
    def status(status)
        @status = status
        return self
    end

    public
    def line
        result = "#{HTTPIE} #{@method} #{ENDPOINT}/sips/#{@guid} "
        result += "title='#{@title}' " unless @title.nil?
        result += "sourceUri='#{@sourceUri}' " unless @sourceUri.nil?
        result += "text='#{@text}' " unless @text.nil?
        result += "notes='#{@notes}' " unless @notes.nil?
        result += "originTimestamp='#{@originTimestamp}' " unless @originTimestamp.nil?
        result += "due='#{@due}' " unless @due.nil?
        result += "status='#{@status}' " unless @status.nil?
        result += "tags:='#{@tags}' " unless @tags.nil? or @tags.empty?
        return result.strip
    end
end

class CreateSipRequest < SipRequest
    def initialize
        @method = 'PUT'
        @guid = SecureRandom.uuid
    end
end

class ChangeSipRequest < SipRequest
    def initialize
        @method = 'PATCH'
    end

    public
    def guid(guid)
        @guid = guid
        return self
    end
end

