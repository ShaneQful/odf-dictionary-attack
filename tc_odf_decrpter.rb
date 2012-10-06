require 'test/unit'
require 'odf_decrpter.rb'

class TC_ODFDecrpter < Test::Unit::TestCase
	def setup
		@test_odf_decrypter = ODFDecrpter.new
		# Setup Encrypted test
		file = File.open#('doc/content.xml','rb') #Content xml from odf
		encrypted_text = ''
		file.readlines.each do |line|
			encrypted_text += line
		end
		@test_odf_decrypter.encrypted_text = encrypted_text
		#Setup initvectors and salts
		@test_odf_decrypter.initialization_vector = Base64.decode64("cVee3d2dh1M=")
		@test_odf_decrypter.salt = Base64.decode64("lykzl3lw8LtNOx8WEL9gmQ==")
		@test_odf_decrypter.hashing_algorithm = 'SHA1'
		@test_odf_decrypter.iteration_count = 1024
		@test_odf_decrypter.decryption_algorithm = 'BF-CFB'
	end
	def test_initialize
		assert(@test_odf_decrypter.encrypted_text, 'No encrypted text in the decrypter')   
	end
	def test_check_password
		assert(@test_odf_decrypter.check_password?('test'), 'Returned false for the correct password')
		assert(!(@test_odf_decrypter.check_password?('not password')), 'Returned true for an incorrect correct password')
	end
end
