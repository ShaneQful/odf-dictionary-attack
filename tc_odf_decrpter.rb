require 'test/unit'
require 'odf_decrpter.rb'

class TC_ODFDecrpter < Test::Unit::TestCase
	def setup
		@test_odf_decrypter = ODFDecrpter.new 'doc/context.xml'
		#Setup initvectors and salts
	end
	def test_initialize
		assert(@test_odf_decrypter.encrypted_text, 'No encrypted text in the decrypter')   
	end
	def test_check_password
		assert(@test_odf_decrypter.check_password? 'test', 'Returned false for the correct password')
		assert(!(@test_odf_decrypter.check_password? 'not password'), 'Returned true for an incorrect correct password')
	end
end
