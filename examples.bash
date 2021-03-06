#!/bin/bash
set -o errexit -o nounset -o pipefail
echo 'Just examples; do not run this file.'
exit 0

# Creates new private key in ./key.pem and CSR is redirected to req.pem.
openssl req -new -newkey rsa:2048 -nodes -keyout key.pem   >  req.pem
# Using -out instead of redirection.
openssl req -new -newkey rsa:2048 -nodes -keyout key.pem -out req.pem
# No user input required.
openssl req -new -newkey rsa:2048 -nodes -keyout key.pem -out req.pem \
            -subj '/CN=example.com/O=Example Com/C=US/ST=Oregon/L=Portland'
# User must enter password on command line to encrypt the key.
openssl req -new -newkey rsa:2048        -keyout key.pem -out req.pem \
            -subj '/CN=example.com/O=Example Com/C=US/ST=Oregon/L=Portland'


# Decrypt private key for later use.
openssl rsa < ./demoCA/private/cakey.pem > ./demoCA/private/cakey.plaintext.pem

# Does not work. No Error message.
openssl ca -out ./out.crt < ./req.pem

# Sign a cert with CA.pl.
cp req.pem newreq.pem
../CA.pl -sign

# Sign a cert in a reasonable and transparent way.
cat req.pem | openssl x509 -req -CA ./demoCA/cacert.pem \
                                -CAkey ./demoCA/private/cakey.plaintext.pem \
                                -CAserial x.srl -CAcreateserial

# Create a CA cert and key.
openssl req -new -newkey rsa:2048 -nodes -x509 -days 1095 \
            -keyout ca.key -out ca.crt \
            -subj '/CN=example.com/O=Example Com/C=US/ST=Oregon/L=Portland'

