# schleuder-web, a web interface for Schleuder3

This is a full featured web interface to administrate [Schleuder v3](https://0xacab.org/schleuder/schleuder)-lists and subscriptions.

##  Installation

### To have a glimpse

1. ./bin/setup
1. ./bin/start
1. Visit http://localhost:3000/

### To run productively

1. Mandatory: In `config/secrets.yml` change `secret_key_base` or set the environment variable SECRET_KEY_BASE.
1. Mandatory: In `config/schleuder-web.yml` add `tls_fingerprint` and `api_key` (get them from the admins that run Schleuder's api-daemon). You can also set them through the environment variables SCHLEUDER_TLS_FINGERPRINT and SCHLEUDER_API_KEY.
1. Optional: edit `config/database.yml`.
1. `bundle install --without development`.
1. `bundle exec rake db:setup RAILS_ENV=production`.
1. Run `RAILS_ENV=production bundle exec rake assets:precompile` to precompile all images and css files.
1. Setup mod_passenger, or a proxy + `bundle exec rails server -e production`.


## Usage

1. Log into the webinterface with email "root@localhost" and password "slingit!".


## TODO

See also `rake notes`

## Testing

We use rspec to test our code. To execute the test suite run:

```
bundle exec rspec
```

We are working on extendig the test coverage.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md).

## Code of Conduct

We adopted a code of conduct. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License

GNU GPL version 3.

## Screenshot

<kbd>
![Screenshot of schleuder-web](doc/schleuder-web-screenshot.png)
</kbd>

