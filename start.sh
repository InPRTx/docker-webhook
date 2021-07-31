#!/usr/bin/env sh
mkdir "/ssl"
cd /ssl
openssl ecparam -genkey -name secp384r1 -out nginx.ec.key
#openssl ec -in nginx.ec.key -text -noout

# CSR
openssl req -new -sha256 -key nginx.ec.key -subj "/CN=devops/C=BM/ST=Bermudian/L=Bermudian/O=Org/OU=IT" -out nginx.ec.csr
#openssl req -in nginx.ec.csr -text -noout
#openssl req -in nginx.ec.csr -text -noout | grep -i "Signature.*SHA256" && echo "All is well"

# Certificate
openssl req -x509 -sha256 -days 365 -key nginx.ec.key -in nginx.ec.csr -out nginx.ec.crt
/usr/local/bin/webhook -secure -cert /ssl/nginx.ec.crt -key /ssl/nginx.ec.key $@
exit 0