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
$run dnf update
packages="ruby-devel redhat-rpm-config gcc gcc-c++ libxml2-devel libxslt-devel tar gzip make zlib-devel openssl-devel libsq3-devel libsodium which patch git bzip2"
# centos doesn't provide these ruby classes in their stdlib.
$run dnf install -y ruby rubygem-bigdecimal rubygem-json rubygem-io-console $packages
# Must reinstall it, otherwise the data is not found. o_O
$run dnf reinstall -y tzdata
$run gem install bundler

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
               --env SCHLEUDERWEB_DB_FILE=/data/db.sqlite \
               --env SCHLEUDERWEB_CONFIG_FILE=/data/schleuder-web.yml \
               --volume /data \
               --port 3000 \
               --user user \
               --cmd '/entrypoint.sh' \
               $image_id 

$run git clone -b ${SCHLEUDER_CI_BRANCH:-master} --depth 1 https://0xacab.org/schleuder/schleuder-web.git /app
commit_id="$($run git log --format='%h' -n 1)"
$run rm -rf .git

$run bundle config set --local without 'development test'
$run bundle config set --local path '.bundle'
$run bundle install --jobs $(nproc)
# The secret key is not actually used, but rails complains if it's unset.
$run bundle exec rake assets:precompile SECRET_KEY_BASE="foo"

buildah config --user root $image_id
# Clean up (after using useradd, but before configuring `appuser` as user)
$run dnf remove -y $packages
$run dnf clean all
$run rm -rf "/root/.bundle" "/var/cache/" "/var/log/" "/usr/share/gems/cache"

# Make the runtime run the app as appuser.
# We couldn't add this option to the previous call to `buildah config`, because it makes all subsequent calls to `buildah run` run as this user, which is not deinstall and clean up the FS.
buildah config --user user $image_id

buildah commit $image_id localhost/schleuder-web:$commit_id

test -n "$CI_REGISTRY_USER" && {
  podman push --creds="$CI_REGISTRY_USER:$CI_REGISTRY_PASSWORD" localhost/schleuder-web:$commit_id "docker://$CI_REGISTRY_IMAGE:$commit_id"
  podman push --creds="$CI_REGISTRY_USER:$CI_REGISTRY_PASSWORD" localhost/schleuder-web:$commit_id "docker://$CI_REGISTRY_IMAGE:latest"
}

