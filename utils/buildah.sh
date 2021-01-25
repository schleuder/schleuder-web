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

image_id=$(buildah from --pull docker.io/ruby:2.5-slim)

run="buildah run $image_id --"
$run apt-get update 
$run apt-get --no-install-recommends upgrade -y
$run apt-get install --no-install-recommends -y ruby libxml2 zlib1g libsqlite3-0 git ruby-dev libxml2-dev zlib1g-dev libsqlite3-dev build-essential
$run apt-get clean

$run gem install bundler

buildah config --workingdir /app \
               --author "schleuder dev team <team@schleuder.org>" \
               --label summary="Run schleuder-web, from master branch" \
               --label maintainer="schleuder dev team <team@schleuder.org>" \
               --env RAILS_ENV=production \
               --env SCHLEUDERWEB_DB_FILE=/data/db.sqlite \
               --env SCHLEUDERWEB_CONFIG_FILE=/data/schleuder-web.yml \
               --cmd "bundle exec rails server" \
               $image_id 

$run git clone --depth 1 https://0xacab.org/schleuder/schleuder-web.git /app
commit_id="$($run git log --format='%h' -n 1)"
$run rm -rf .git

$run bundle config set --local without 'development test'
$run bundle install
# The secret key is not actually used, but rails complains if it's unset.
$run bundle exec rake assets:precompile SECRET_KEY_BASE="foo"

$run bash -c '
if test -f db/production.sqlite3; then
  bundle exec rake db:migrate SECRET_KEY_BASE="foo"
else
  bundle exec rake db:setup SECRET_KEY_BASE="foo"
fi
'

$run apt-get purge --autoremove -y git ruby-dev libxml2-dev zlib1g-dev libsqlite3-dev build-essential
$run rm -rf "/usr/local/bundle/cache/" "/var/lib/apt/lists/" "/root/.bundle"

buildah commit $image_id schleuder-web:$commit_id
buildah commit $image_id schleuder-web:latest

test -n "$CI_REGISTRY_USER" && {
  podman push --creds="$CI_REGISTRY_USER:$CI_REGISTRY_PASSWORD" schleuder-web "docker://$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA"
  podman push --creds="$CI_REGISTRY_USER:$CI_REGISTRY_PASSWORD" schleuder-web "docker://$CI_REGISTRY_IMAGE:latest"
}

