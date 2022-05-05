#!/bin/sh

# All actions based on https://docs.gitlab.com/ee/install/azure/
export config_file=/etc/gitlab/gitlab.rb
export external_url="${URL}"
export password="${PASS}"
export personal_access_token="${TOKEN}"

# sleep for DNS to refresh
sleep 300

# Replace External  URL
sed -i "s,^external_url.*$,external_url '$external_url',g" $config_file

# Disable HTTPS Redirect
perl -pi.bak1 -e 's/(^nginx\[.redire.*$)/# $1/g' $config_file

# Disable integrated SSL Certificate
perl -pi.bak2 -e 's/(^nginx\[.ssl_certifi.*$)/# $1/g' $config_file

# Enable Lets Encrypt (if commented)
perl -pi.bak3 -e 's/# (letsencrypt\[.enable.*= )(.*$)/$1true/g' $config_file

# Enable Lets Encrypt (if not commented)
perl -pi.bak3 -e 's/(letsencrypt\[.enable.*= )(.*$)/$1true/g' $config_file

# Reconfigure Gitlab after Config Modification
gitlab-ctl reconfigure

# Prevent Reset after reboot
mv /opt/bitnami/apps/gitlab/bnconfig /opt/bitnami/apps/gitlab/bnconfig.bak

# Resetting Password
gitlab-rails runner -e production "  \
  user = User.find(1);                  \
  user.password = user.password_confirmation = '$password'; \
  user.save!"

# Generate Automation PAT
gitlab-rails runner " \
  token = User.find(1).personal_access_tokens.create(scopes: [:api, :write_repository, :write_registry, :sudo], name: 'automation');  \
  token.set_token('$personal_access_token');  \
  token.save!"
