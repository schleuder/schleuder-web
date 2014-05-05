# Schleuder, rails-edition

This is an attempt to rewrite schleuder, the encrypted mailinglist manager and
group-gateway.

The non-web-code resides in `app/lib`.

Call it with: `./bin/schleuder listname@hostname < email`.


##  Installation

1. `bundle install`.
1. Optional: edit config/database.yml.
1. Optional: edit config/schleuder.yml.
1. `bundle exec rake db:setup`.
1. To create a list:
  
  1. mkdir its list-directory (see schleuder.yml),
  1. generate a gpg-key-pair,
  1. in `rails console`: `List.create(email: listname@hostname, fingerprint: thenewlygeneratedfingerprint)`

Log into the webinterface with root@localhost and password "slingit!".


## Limitations

Only tested with ruby 2.1 up to now.


## TODO

 * Create lists
 * superadmin-flag for Accounts
 * Edit own subscriptions as non-admin
 * Unsubscribe self as non-admin
 * Button: send key to all subscribed addresses

See also `rake notes`


## License

GNU GPL version 3.
