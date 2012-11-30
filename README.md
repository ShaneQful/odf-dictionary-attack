### odf-dictionary-attack

This is some code written as part of my final year project to run dictionary attacks against encrypted
ODF files.

* While this code is written in ruby the OpenSSL library it is taking advantage of is written in C and assembly so it still performs relatively well against other crackers for ODF files.  

Usage:

```bash
unzip file.odf
ruby odf_decrypter.rb file_unzipped/META-INF/manifest.xml dictionary_file file_unzipped/content.xml 
```

* DecryptDoc.sh is a quick script using wvWare to attack MSOffice files but is of no real use due to how it compares against other cracking software.

* This software was written with reference to [Decrypting ODF Files](http://ringlord.com/dl/Decrypting%20ODF%20Files.pdf) by K. Udo Schuermann of Ringlord Technologies.

* John the ripper now has the ability to decrypt ODF files and does so faster than this software and I recommend its use instead.

### License:

* This software is MIT licensed see link for details

* http://www.opensource.org/licenses/MIT