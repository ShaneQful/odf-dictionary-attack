#!/usr/bin/ruby

# Copyright (c) 2012 Shane Quigley
# 
# This software is MIT licensed see link for details
# http://www.opensource.org/licenses/MIT

require 'openssl'
require 'base64'
require 'zlib'
require 'stringio'

file = File.open(ARGV[0],'rb') #Content xml from odf
encrypted = ''
file.readlines.each do |line|
	encrypted += line
end
#puts 'What\'s passowrd would you like to try:'
password = ARGV[1]
#passwordHash = OpenSSL::Digest::SHA256.digest(password)
passwordHash = OpenSSL::Digest::SHA1.digest(password)
#puts 'What\'s the salt?'
salt = Base64.decode64("lykzl3lw8LtNOx8WEL9gmQ==") # Might need to add \n to end
#puts 'What\'s the iteration count?'
iter = 1024
key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(passwordHash, salt, iter, 16)
#puts 'What\'s the initialization vector?'
iv = Base64.decode64("cVee3d2dh1M=")
#decipher = OpenSSL::Cipher::AES.new(256, :CBC)
decipher = OpenSSL::Cipher.new('BF-CFB')
decipher.decrypt
decipher.key = key
decipher.iv = iv
plain = decipher.update(encrypted) + decipher.final
#puts plain
#delate plaintext
begin
	zstream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
	buf = zstream.inflate(plain)
	zstream.finish
	zstream.close
	puts buf
rescue
	puts 'Wrong Password'
end


