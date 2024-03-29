#!/usr/bin/ruby

# Copyright (c) 2012 Shane Quigley
# 
# This software is MIT licensed see link for details
# http://www.opensource.org/licenses/MIT

require 'test/unit'
require 'odf_decrypter.rb'

class TC_ODFDecrpter < Test::Unit::TestCase
	def setup
		parser = ManifestParser.new 'TestFiles/blowfish_unzipped/META-INF/manifest.xml'
		decrypter_hash = parser.parse
		@blowfish_odf_decrypter = ODFDecrpter.new decrypter_hash
		# Setup Encrypted test
		file = File.open('TestFiles/blowfish_unzipped/content.xml','rb') #Content xml from odf
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
	
	def test_dictionary_attack
		assert(!@blowfish_odf_decrypter.dictionary_attack('TestFiles/dictionary_without_password.txt'),'Blowfish-Test-File : Password found in a dictionary without the password')
		assert(@blowfish_odf_decrypter.dictionary_attack('TestFiles/dictionary_with_password.txt'),'Blowfish-Test-File : Not found in a dictionary with the password')
	end
end
