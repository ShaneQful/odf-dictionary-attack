require 'rexml/document'

class ManifestParser
	def initialize file_path
		file = File.new(file_path,'rb')
		@manifest = REXML::Document.new file
		@decrypter_hash = Hash.new
	end
	
# 	attr_accessor:encrypted_text, :hashing_algorithm, :size, :salt, :iteration_count, :initialization_vector,:checksum, :decryption_algorithm
	def parse
		content_element = find_context_xml()
		@decrypter_hash['size'] = content_element.attributes['size']
		content_element.elements.each do |encryption_data|
			@decrypter_hash['checksum'] = encryption_data.attributes['checksum']
			@decrypter_hash['checksum-type'] = encryption_data.attributes['checksum-type']
			encryption_data.elements.each do |element|
				put_attributes_in_the_map element
			end
		end
		return @decrypter_hash
	end
	
	#Thank god for code folding hiding the shame of this method
	def put_attributes_in_the_map element
		if(element.attributes['algorithm-name'])
			@decrypter_hash['decryption_algorithm'] = element.attributes['algorithm-name']
		end
		if(element.attributes['initialisation-vector'])
			@decrypter_hash['initialization_vector'] = element.attributes['initialisation-vector']
		end
		if(element.attributes['key-derivation-name'])
			@decrypter_hash['key-derivation-name'] = element.attributes['key-derivation-name']
		end
		if(element.attributes['iteration-count'])
			@decrypter_hash['iteration_count'] = element.attributes['iteration-count']
		end
		if(element.attributes['salt'])
			@decrypter_hash['salt'] = element.attributes['salt']
		end
		if(element.attributes['start-key-generation-name'])
			@decrypter_hash['hashing_algorithm'] = element.attributes['start-key-generation-name']
		end
		if(element.attributes['key-size'])
			@decrypter_hash['key-size'] = element.attributes['key-size']
		end
	end
	
	#Proabably should do this recursively
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
	
	attr_reader :decrypter_hash
	private :find_context_xml, :put_attributes_in_the_map
end

# parser = ManifestParser
