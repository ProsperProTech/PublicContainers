import OpenSSL
import jks

# dumping the key and cert to ASN1
dumped_cert = OpenSSL.crypto.dump_certificate(OpenSSL.crypto.FILETYPE_ASN1, cert)
dumped_key = OpenSSL.crypto.dump_privatekey(OpenSSL.crypto.FILETYPE_ASN1, key)

# creating a private key entry
pke = jks.PrivateKeyEntry.new('self signed cert', [dumped_cert], dumped_key, 'rsa_raw')

# creating a jks keystore with the private key, and saving it
keystore = jks.KeyStore.new('jks', [pke])
keystore.save('./my_keystore.jks', 'my_password')