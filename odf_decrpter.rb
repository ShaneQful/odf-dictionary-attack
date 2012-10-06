#!/usr/bin/ruby

require 'openssl'
require 'base64'
require 'zlib'

class ODFDecrpter
	def initialize #content_file
# 		file = File.open(content_file,'rb') #Content xml from odf
# 		@encrypted_text = ''
# 		file.readlines.each do |line|
# 			@encrypted_text += line
# 		end
	end

	def parse manifest_file
=begin
		#Set all the neccessary variables for this ODF
		@encrypted_text #content.xml
		
		@hashing_algorithm
		
		@salt
		@iteration_count
		
		@initialization_vector
		@decryption_algorithm
		
		@checksum
=end
	end
	
	# Dictionary :path to textfile of words separated by new line
	def dictionary_attack dictionary
		file = File.open(dictionary, "rb")
		file.readlines.each do |line|
			if(check_password? line)
				return line
			end
		end
		return false
	end
	
	def check_password? password
		hash = OpenSSL::Digest.digest(@hashing_algorithm, password.chomp!)
		key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(hash, @salt, @iteration_count, 16)
		deflated_plain_text = decrypt key
		if(inflate_plain_text(deflated_plain_text))
			text = inflate_plain_text(deflated_plain_text)
			if(text.size == @size)
# 				return true
				#do a checksum to make sure
# 				sha256 = Digest::SHA1.new
# 				digest = sha256.digest text[0 .. 1024]
# 				puts text[0 .. 1024]
# 				puts Base64.encode64 digest
				return true
			end
			#Use the checksum after it inflates
		else
			return false
		end
	end
	
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
	attr_accessor:encrypted_text, :hashing_algorithm, :size, :salt, :iteration_count, :initialization_vector,:checksum, :decryption_algorithm
	private :decrypt, :inflate_plain_text
end

if __FILE__ == $0
	decrypter = ODFDecrpter.new
	# Setup Encrypted test
	puts Dir.pwd
	file = File.open('TestFiles/doc/content.xml','rb') #Content xml from odf
	encrypted_text = ''
	file.readlines.each do |line|
	encrypted_text += line
	end
	decrypter.encrypted_text = encrypted_text
	#Setup initvectors and salts
	decrypter.initialization_vector = Base64.decode64("cVee3d2dh1M=")
	decrypter.salt = Base64.decode64("lykzl3lw8LtNOx8WEL9gmQ==")
	decrypter.hashing_algorithm = 'SHA1'
	decrypter.iteration_count = 1024
	decrypter.size = 31879840
	decrypter.decryption_algorithm = 'BF-CFB'
	decrypter.checksum = Base64.decode64('t2OrLDkrl/RUnmfRQpXimcWWH8o=')
	#puts Base64.decode64('t2OrLDkrl/RUnmfRQpXimcWWH8o=')
	#Really have to write that parser	
	startTime = Time.new
	puts decrypter.dictionary_attack ARGV[0] #Word List arg 1
	endTime = Time.new
	puts endTime - startTime
end
