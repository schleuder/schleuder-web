FROM ruby:2.5

RUN apt-get update && apt-get --no-install-recommends upgrade -y
RUN apt-get install --no-install-recommends -y ruby-dev 
RUN apt-get clean && rm -r /var/cache/apt/archives/*

RUN gem install bundler

RUN git clone https://0xacab.org/schleuder/schleuder-web.git /app
RUN rm -rf /app/.git

WORKDIR /app

ENV RAILS_ENV production
RUN bundle config set --local without 'development test'
RUN bundle install
# The secret key is not actually used, but rails complains if it's unset.
RUN bundle exec rake db:setup SECRET_KEY_BASE="foo"
RUN bundle exec rake assets:precompile SECRET_KEY_BASE="foo"

CMD ["bundle", "exec", "rails", "server", "-e", "production"]

# To run this image you have to set several environment variables:
# * SECRET_KEY_BASE — to secure your cookies. If this changes between runs, all existing login sessions will become invalid.
# * SCHLEUDER_TLS_FINGERPRINT — The fingerprint of your schleuder-api-daemon. Run `schleuder cert fingerprint` to get it.
# * SCHLEUDER_API_KEY — An API-key from your schleuder.yml
#
# The following environment variables are optional:
# * SCHLEUDER_API_HOST — on which host schleuder-api-daemon runs.
# * SCHLEUDER_API_PORT — on which port schleuder-api-daemon listens.
