#!/usr/bin/ruby

require 'securerandom'
require 'tempfile'

require_relative 'config.rb'
require_relative 'CreateSipRequest.rb'
require_relative 'PantaRheiGateway.rb'


class CliBoundary
	MODES = {
		'c' => :create_sip,
		'r' => :read_sips,
		'u' => :update_sip,
		'd' => :delete_sip,
		'ci' => :create_sip_interactively,
		'ui' => :update_sip_interactively
	};

	def initialize(gateway)
		@gateway = gateway
	end

	def run
		mode = read_mode
		self.send MODES[mode]
	end

	def read_mode
		MODES.keys.include?(ARGV[0]) ? ARGV.shift : 'r'
	end


	# create

	def create_sip
		title = get_arg 'title', 'ti', 't'
		sourceUri = get_arg 'sourceUri', 's'
		tags = get_tags_from_args
		text = get_arg 'text', 'te'

		request = CreateSipRequest.new
		.title(title)
		.sourceUri(sourceUri)
		.tags(tags)
		.text(text)

		@gateway.send request
	end

	def get_arg(*names)
		ARGV.each do |arg|
			names.each do |name|
				return arg[arg.index('=')+1..-1] if arg.start_with?(name + '=')
			end
		end
		return nil
	end

	def get_tags_from_args
		result = ARGV.select {|arg| arg.start_with? '+'}
		delete_plus_prefix result
	end

	def delete_plus_prefix tags
		tags.map {|tag| tag.delete '+'}
	end


	# create interacticely

	def create_sip_interactively
		title = prompt 'title'
		sourceUri = prompt 'sourceUri'
		tags = prompt_for_tags
		text = prompt_editor

		request = CreateSipRequest.new
		.title(title)
		.sourceUri(sourceUri)
		.tags(tags)
		.text(text)

		@gateway.send request
	end

	def prompt(prompt, default = '')
		input = `read -p '#{prompt}: ' -e -i '#{default}' result && echo $result`
		result = input.strip
		return result != "" ? result : nil
	end

	def prompt_for_tags(default = '')
		tagsString = prompt('tags', default)
		unless tagsString.nil?
			tags = tagsString.split
			tags = delete_plus_prefix tags 
		end
		return tags
	end

	def prompt_editor(default = '')
		file = Tempfile.new('dio-ci')
		begin
			file.write default
			file.flush
			system "$EDITOR #{file.path}"
			file.rewind
			result = file.read
			return result.empty? ? nil : result.chomp
		ensure
			file.unlink
			file.close
		end
	end
	
	
	# read

	def read_sips
		query = ARGV.join ' '
		@gateway.query query
	end


	# update

	def update_sip
		guid = ARGV.shift
		title = get_arg 'title', 'ti', 't'
		sourceUri = get_arg 'sourceUri', 's'
		tags = get_tags_from_args
		text = get_arg 'text', 'te'

		request = ChangeSipRequest.new
		.guid(guid)
		.title(title)
		.sourceUri(sourceUri)
		.tags(tags)
		.text(text)

		@gateway.send request
	end


	# update interactvely
	
	def update_sip_interactively
		guid = ARGV[0]

		sip = @gateway.read(guid)

		title = prompt 'title', sip[:title]
		sourceUri = prompt 'sourceUri', sip[:sourceUri]
		tags = prompt_for_tags sip[:tags].join ' '
		text = prompt_editor sip[:text]

		request = ChangeSipRequest.new
		.guid(guid)
		.title(title)
		.sourceUri(sourceUri)
		.tags(tags)
		.text(text)

		@gateway.send request
	end


	# delete

	def delete_sip
		ARGV.each do |guid|
			@gateway.delete guid
		end
	end
end

cli = CliBoundary.new PantaRheiGateway.new
cli.run
