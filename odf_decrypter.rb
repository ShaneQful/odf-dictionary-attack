#!/usr/bin/ruby

require 'openssl'
require 'base64'
require 'zlib'
require 'manifest_parser.rb'

class ODFDecrpter
	def initialize decrypter_hash #Hash as in the ruby hashmap. Yeah might have to rename this
		@hashing_algorithm = decrypter_hash['hashing_algorithm']
		@salt = decrypter_hash['salt']
		@iteration_count = decrypter_hash['iteration_count']
		@initialization_vector = decrypter_hash['initialization_vector']
		@decryption_algorithm = decrypter_hash['decryption_algorithm']		
		@size = decrypter_hash['size']		
		@checksum = decrypter_hash['checksum']
		@checksum_algorithm = decrypter_hash['checksum-type']
		@key_size = decrypter_hash['key-size']
	end
	
	# Dictionary :path to textfile of words separated by new line
	def dictionary_attack dictionary
		file = File.open(dictionary, "rb")
		file.readlines.each do |line|
			if(check_password? line.chomp)
				return line
			end
		end
		return false
	end
	
	def check_password? password
		hash = OpenSSL::Digest.digest(@hashing_algorithm, password)
		key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(hash, @salt, @iteration_count, @key_size)
		deflated_plain_text = decrypt key
		checksum  = OpenSSL::Digest.digest(@checksum_algorithm, deflated_plain_text[0 .. 1024])
		if(checksum == @checksum)
			return true
		else
			return false
		end
	end
	
	attr_accessor:encrypted_text
	
	private
	
	def decrypt key
		decipher = OpenSSL::Cipher.new(@decryption_algorithm)
		decipher.decrypt
		decipher.key = key
		decipher.iv = @initialization_vector
		plain = decipher.update(@encrypted_text) + decipher.final
		return plain # I know this is uneccessary it's just cleaner
	end
	
	def inflate_plain_text deflated_plain_text
		begin
			zstream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
			buf = zstream.inflate(deflated_plain_text)
			zstream.finish
			zstream.close
			return buf
		rescue
			return false
		end
	end
	
	
	#So global variables neccessary for decryption can be set by hand
	#, :hashing_algorithm, :size, :salt, :iteration_count, :initialization_vector,:checksum, :decryption_algorithm
end

=begin
if __FILE__ == $0
# 	# Setup Encrypted test
# 	puts Dir.pwd
		file = File.open(ARGV[2],'rb') #Content xml from odf
		encrypted_text = ''
		file.readlines.each do |line|
			encrypted_text += line
		end
# 	decrypter.encrypted_text = encrypted_text
# 	#Setup initvectors and salts
# 	decrypter.initialization_vector = Base64.decode64("cVee3d2dh1M=")
# 	decrypter.salt = Base64.decode64("lykzl3lw8LtNOx8WEL9gmQ==")
# 	decrypter.hashing_algorithm = 'SHA1'
# 	decrypter.iteration_count = 1024
# 	decrypter.size = 31879840
# 	decrypter.decryption_algorithm = 'BF-CFB'
# 	decrypter.checksum = Base64.decode64('t2OrLDkrl/RUnmfRQpXimcWWH8o=')
# 	#puts Base64.decode64('t2OrLDkrl/RUnmfRQpXimcWWH8o=')
# 	#Really have to write that parser	
	parser = ManifestParser.new ARGV[0]
	puts parser.parse.inspect
	decrypter = ODFDecrpter.new parser.decrypter_hash
	decrypter.encrypted_text = encrypted_text
	startTime = Time.new
# 	decrypter.check_password? 'test'
	puts decrypter.dictionary_attack ARGV[1] #Word List arg 1
	endTime = Time.new
	puts endTime - startTime
end
=end