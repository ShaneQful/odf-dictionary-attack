require 'rexml/document'
require 'base64'

class ManifestParser
	def initialize file_path
		file = File.new(file_path,'rb')
		@manifest = REXML::Document.new file
		@decrypter_hash = Hash.new
	end
	
	def parse
		content_element = find_context_xml()
		@decrypter_hash['size'] = content_element.attributes['size'].to_i
		content_element.elements.each do |encryption_data|
			@decrypter_hash['checksum'] = Base64.decode64(encryption_data.attributes['checksum'])
			@decrypter_hash['checksum-type'] = encryption_data.attributes['checksum-type']
			encryption_data.elements.each do |element|
				put_attributes_in_the_map element
			end
		end
		#Turn them all into the right format for ruby to understand
		set_ruby_name_for_encryption
		set_ruby_name_for_hashing_algorithm
		if(@decrypter_hash['key-size'] == nil)#Saw a encrypted blowfish odt online with out key size
			@decrypter_hash['key-size'] = 16
		end
		return @decrypter_hash
	end
	
	attr_reader :decrypter_hash
	private	
	def set_ruby_name_for_hashing_algorithm
		if(@decrypter_hash['hashing_algorithm'].include?('SHA1') || @decrypter_hash['hashing_algorithm'].include?('sha1'))
			@decrypter_hash['hashing_algorithm'] = 'SHA1'
		elsif(@decrypter_hash['hashing_algorithm'].include?('SHA256') || @decrypter_hash['hashing_algorithm'].include?('sha256'))
			@decrypter_hash['hashing_algorithm'] = 'SHA256'
		end
	end
	
	def set_ruby_name_for_encryption
		decryption_algorithm = ''
		if(@decrypter_hash['decryption_algorithm'].include?('Blowfish'))
			decryption_algorithm = 'BF'
		elsif(@decrypter_hash['decryption_algorithm'].include?('aes256'))
			decryption_algorithm = 'AES-256'
		end
		if(@decrypter_hash['decryption_algorithm'].include?('CBC') ||@decrypter_hash['decryption_algorithm'].include?('cbc'))
			decryption_algorithm += '-CBC'
		elsif(@decrypter_hash['decryption_algorithm'].include?('CFB') ||@decrypter_hash['decryption_algorithm'].include?('cfb'))
			decryption_algorithm += '-CFB'
		end
		@decrypter_hash['decryption_algorithm'] = decryption_algorithm
	end
	#Thank god for code folding hiding the shame of this method
	def put_attributes_in_the_map element
		if(element.attributes['algorithm-name'])
			@decrypter_hash['decryption_algorithm'] = element.attributes['algorithm-name']
		end
		if(element.attributes['initialisation-vector'])
			@decrypter_hash['initialization_vector'] = Base64.decode64(element.attributes['initialisation-vector'])
		end
		if(element.attributes['key-derivation-name'])
			@decrypter_hash['key-derivation-name'] = element.attributes['key-derivation-name']
		end
		if(element.attributes['iteration-count'])
			@decrypter_hash['iteration_count'] = element.attributes['iteration-count'].to_i
		end
		if(element.attributes['salt'])
			@decrypter_hash['salt'] = Base64.decode64(element.attributes['salt'])
		end
		if(element.attributes['start-key-generation-name'])
			@decrypter_hash['hashing_algorithm'] = element.attributes['start-key-generation-name']
		end
		if(element.attributes['key-size'] && !@decrypter_hash['key-size'])#I only want the keysize for the derivation algorithm
			@decrypter_hash['key-size'] = element.attributes['key-size'].to_i
		end
	end
	
	#Proabably should do this recursively
	#Might find the smallest file rather than content.xml
	#because I believe that would help peformance
	def find_context_xml
		@manifest.elements.each do |e|
			e.elements.each do |e1|
				if(e1.attributes['full-path'] == 'content.xml')
					return e1
				end
			end
		end
		#Throw exception if it gets this far
		"Something has gone terribly wrong :("
	end
end

# if __FILE__ == $0
# 	parser = ManifestParser.new ARGV[0]
# 	parser.parse
# 	puts parser.decrypter_hash.inspect
# end
