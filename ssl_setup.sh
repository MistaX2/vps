#!/bin/bash

# --- Settings ---
DOMAIN="Domain"
EMAIL="ex@gmail.com"
CERT_PATH="/root/cert.crt"
KEY_PATH="/root/private.key"

echo "-----------------------------------------------"
echo "Starting SSL Installation for $DOMAIN"
echo "-----------------------------------------------"

# 1. acme.sh install කිරීම
curl https://get.acme.sh | sh

# 2. Default CA එක Let's Encrypt ලෙස සැකසීම
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

# 3. Account එක register කිරීම
~/.acme.sh/acme.sh --register-account -m $EMAIL

# 4. Standalone mode එකෙන් SSL issue කරගැනීම
# මතක ඇතුව 80 port එක free තියාගන්න මේ වෙලාවේදී
~/.acme.sh/acme.sh --issue -d $DOMAIN --standalone

# 5. Certificate එක අදාළ path වලට install කිරීම
~/.acme.sh/acme.sh --installcert -d $DOMAIN \
--key-file $KEY_PATH \
--fullchain-file $CERT_PATH

echo "-----------------------------------------------"
echo "SSL Installation Complete!"
echo "Cert: $CERT_PATH"
echo "Key: $KEY_PATH"
echo "-----------------------------------------------"
