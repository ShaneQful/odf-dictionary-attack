require 'openssl'
require 'base64'
require 'zlib'

class ODFDecrpter
	def initialize content_file
		@encrypted = content_file
	end
	
	def parse manifest_file
=begin
		#Set all the neccessary variables for this ODF
		@encrypted #content.xml
		
		@hashing_algorithm
		
		@salt
		@iteration_count
		
		@initialization_vector
		@decryption_algorithm
=end
	end
	
	# Dictionary a textfile of words separated by new line
	def dictionary_attack dictionary
		
	end
	
	private:
	def test_password? password
		hash = OpenSSL::Digest.digest(@hashing_algorithm, password)
		key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(hash, @salt, @iteration_count, 16)
		deflated_plain_text = decrypt key
		if(inflate_plain_text(deflated_plain_text))
			return true
		else
			return false
		end
	end
	
	def decrypt key
		decipher = OpenSSL::Cipher.new(@decryption_algorithm)
		decipher.decrypt
		decipher.key = key
		decipher.iv = @initialization_vector
		plain = decipher.update(@encrypted) + decipher.final
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
end