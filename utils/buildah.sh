#!/bin/sh

# To run this image you have to set several environment variables:
# * SECRET_KEY_BASE — to secure your cookies. If this changes between runs, all existing login sessions will become invalid.
# * SCHLEUDER_TLS_FINGERPRINT — The fingerprint of your schleuder-api-daemon. Run `schleuder cert fingerprint` to get it.
# * SCHLEUDER_API_KEY — An API-key from your schleuder.yml
#
# The following environment variables are optional:
# * SCHLEUDER_API_HOST — on which host schleuder-api-daemon runs.
# * SCHLEUDER_API_PORT — on which port schleuder-api-daemon listens.


set -e

unset HISTFILE

image_id=$(buildah from --pull-always registry.code.immerda.ch/immerda/container-images/base/centos:8)

run="buildah run $image_id --"
$run dnf update -y

# Define packages required for building/installing the app and its
# dependencies. These will be removed later.
build_packages="ruby-devel redhat-rpm-config gcc gcc-c++ libxml2-devel libxslt-devel tar gzip make zlib-devel openssl-devel libsq3-devel libsodium which patch git bzip2"
# Define packages required for running the app. These won't be deinstalled
# later.
# Centos provides less ruby classes in their stdlib than other distributions,
# we must install some explicitly (bundler (as of v2.2) doesn't notice this
# when installing the dependencies).
runtime_packages="ruby rubygem-bigdecimal rubygem-json rubygem-io-console"

$run dnf install -y $runtime_packages $build_packages
# Must reinstall it, otherwise the data is not found (was removed by the base image to save some space).
$run dnf reinstall -y tzdata
$run gem install bundler

# An entrypoint-script to run the app.
echo '#!/bin/bash
set -e

if test -z "$SECRET_KEY_BASE"; then
  echo "!!!   Setting random, volatile SECRET_KEY_BASE — login sessions are only valid as long as this process invocation lives."
  export SECRET_KEY_BASE="$(tr -cd \"[:print:]\" </dev/urandom| head -c 20)"
fi

if test -f "$SCHLEUDERWEB_DB_FILE"; then
  bundle exec rake db:migrate
else
  bundle exec rake db:setup
fi

bundle exec rails server
' | $run bash -c 'cat > /entrypoint.sh && chmod 755 /entrypoint.sh'

$run install -d /app -o user -g user

buildah config --workingdir /app \
               --author "schleuder dev team <team@schleuder.org>" \
               --label summary="Run schleuder-web, from master branch" \
               --label maintainer="schleuder dev team <team@schleuder.org>" \
               --env RAILS_ENV=production \
               --env RAILS_LOG_TO_STDOUT=yes \
               --env SCHLEUDERWEB_DB_FILE=/data/db.sqlite \
               --env SCHLEUDERWEB_CONFIG_FILE=/data/schleuder-web.yml \
               --volume /data \
               --port 3000 \
               --user user \
               --cmd '/entrypoint.sh' \
               $image_id 

# Download the app
$run git clone -b ${SCHLEUDER_CI_BRANCH:-master} --depth 1 https://0xacab.org/schleuder/schleuder-web.git /app
commit_id="$($run git log --format='%h' -n 1)"
$run rm -rf .git

# Install dependencies
$run bundle config set --local without 'development test'
$run bundle config set --local path '.bundle'
$run bundle install --jobs $(nproc)
# The secret key is not actually used, but rails complains if it's unset.
$run bundle exec rake assets:precompile SECRET_KEY_BASE="foo"
# Remove sass-related gems. We don't need them anymore (in "production"!) and they consume a lot of space
$run bundle remove bootstrap-sass sass-rails
$run bundle clean
$run sed -i  -e "/^require 'bootstrap/d" -e "/^require 'sass/d" config/initializers/require_libs_and_gems.rb

buildah config --user root $image_id
# Clean up to save space and reduce the attack surface a little
$run dnf remove -y $build_packages
$run dnf clean all
$run bash -c 'rm -rf /app/.bundle/ruby/2.5.0/cache/* ~user/.bundle /var/cache/* /var/log/* /usr/share/gems/cache/* /usr/local/share/gems/cache/*'

# Make the image run commands as 'user' by default
buildah config --user user $image_id

buildah commit $image_id localhost/schleuder-web:$commit_id

test -n "$CI_REGISTRY_USER" && {
  podman push --creds="$CI_REGISTRY_USER:$CI_REGISTRY_PASSWORD" localhost/schleuder-web:$commit_id "docker://$CI_REGISTRY_IMAGE:$commit_id"
  podman push --creds="$CI_REGISTRY_USER:$CI_REGISTRY_PASSWORD" localhost/schleuder-web:$commit_id "docker://$CI_REGISTRY_IMAGE:latest"
}

