require 'test/unit'
require 'base64'
require 'manifest_parser.rb'

class TC_ManifestParser < Test::Unit::TestCase
	def setup
		@blowfish_parser = ManifestParser.new 'TestFiles/blowfish_unzipped/META-INF/manifest.xml'
	end
	def test_initialize
		assert(@blowfish_parser.decrypter_hash, 'Decrypter Hash not initialized')   
	end
	def test_parse
		@blowfish_parser.parse
		assert(@blowfish_parser.decrypter_hash['key-size'] == 16, 'Blowfish-Test-File: Wrong key size')
		assert(@blowfish_parser.decrypter_hash['decryption_algorithm'] == 'BF-CFB','Blowfish-Test-File: Wrong Cipher')
		assert(@blowfish_parser.decrypter_hash['salt'] == Base64.decode64('lykzl3lw8LtNOx8WEL9gmQ=='),'Blowfish-Test-File: Wrong Salt')
		assert(@blowfish_parser.decrypter_hash['key-derivation-name'] == 'PBKDF2','Blowfish-Test-File : Wrong key derivation algorithm')
		assert(@blowfish_parser.decrypter_hash['checksum-type'] == 'SHA1','Blowfish-Test-File : Wrong checksum algorithm')
	end
end