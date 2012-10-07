require 'test/unit'
require 'odf_decrypter.rb'

class TC_ODFDecrpter < Test::Unit::TestCase
	def setup
		parser = ManifestParser.new 'TestFiles/doc/META-INF/manifest.xml'
		decrypter_hash = parser.parse
		@blowfish_odf_decrypter = ODFDecrpter.new decrypter_hash
		# Setup Encrypted test
		file = File.open('TestFiles/doc/content.xml','rb') #Content xml from odf
		encrypted_text = ''
		file.readlines.each do |line|
			encrypted_text += line
		end
		@blowfish_odf_decrypter.encrypted_text = encrypted_text
	end
	def test_initialize
		assert(@blowfish_odf_decrypter.encrypted_text, 'Blowfish-Test-File : No encrypted text in the decrypter')   
	end
	def test_check_password
		assert(@blowfish_odf_decrypter.check_password?('test'), 'Blowfish-Test-File : Returned false for the correct password')
		assert(!(@blowfish_odf_decrypter.check_password?('not the right password')), 'Blowfish-Test-File : Returned true for an incorrect correct password')
	end
end
