#!/bin/bash

set -o nounset
set -o errexit

# Change these for your own domain and mail
export DOMAIN=terraform.kalli.app
export EMAIL=k@kalli.no
 
# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
 
sleep 25
apt-get update
apt-get -y install haproxy

# No package install yet.
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
mv certbot-auto /usr/local/bin
 
# Install the dependencies.
certbot-auto --noninteractive --os-packages-only
 
# Set up config file.
mkdir -p /etc/letsencrypt
cat > /etc/letsencrypt/cli.ini <<EOF
# Uncomment to use the staging/testing server - avoids rate limiting.
# server = https://acme-staging.api.letsencrypt.org/directory
 
# Use a 4096 bit RSA key instead of 2048.
rsa-key-size = 4096
 
# Set email and domains.
email = $EMAIL
domains = $DOMAIN
 
# Text interface.
text = True
# No prompts.
non-interactive = True
# Suppress the Terms of Service agreement interaction.
agree-tos = True
 
# Use the standalone authenticator.
authenticator = standalone
EOF
 
# Obtain cert.
certbot-auto certonly
 
# Set up daily cron job.
CRON_SCRIPT="/etc/cron.daily/certbot-renew"
 
cat > "${CRON_SCRIPT}" <<EOF
#!/bin/bash
#
# Renew the Let's Encrypt certificate if it is time. It won't do anything if
# not.
#
# This reads the standard /etc/letsencrypt/cli.ini.
#
 
# May or may not have HOME set, and this drops stuff into ~/.local.
export HOME="/root"
# PATH is never what you want it it to be in cron.
export PATH="\${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
 
certbot-auto --no-self-upgrade certonly

if service --status-all | grep -Fq 'haproxy'; then
  service haproxy reload
fi
EOF
chmod a+x "${CRON_SCRIPT}"

mkdir -p /etc/haproxy/certs

cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem

chmod -R go-rwx /etc/haproxy/certs
