### odf-dictionary-attack

This is some code written as part of my final year project to run dictionary attacks against encrypted
ODF file.

* The code will be MIT licensed. When I have time to sort that stuff out.

* While this code is written in ruby the OpenSSL library it is taking advantage of is written in C and assembly so it still performs relatively well against other crackers for ODF files.  

Usage:

```bash
unzip file.odf
ruby odf_decrypter.rb file_unzipped/META-INF/manifest.xml dictionary_file file_unzipped/content.xml 
```

* DecryptDoc.sh and .rb are quick scripts using wvWare to attack MSOffice files but are of no real use due to how them compare against other cracking software.

* This software was written with reference to [Decrypting ODF Files](http://ringlord.com/dl/Decrypting%20ODF%20Files.pdf) by K. Udo Schuermann of Ringlord Technologies.

* John the ripper now has the ability to decrypt ODF files and does so faster than this software and I recommend its use instead.