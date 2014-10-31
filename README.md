# Schleuder, rails-edition

This is an attempt to rewrite schleuder, the encrypted mailinglist manager and
group-gateway.

The non-web-code resides in `app/lib`.

##  Installation

1. `bundle install`.
1. Optional: edit config/database.yml.
1. Optional: edit config/schleuder.yml.
1. `bundle exec rake db:setup`.


## Usage

Log into the webinterface with email root@localhost and password "slingit!".

To create a list either use the webinterface or execute:
`./bin/schleuder-newlist`

Receive its public key by sending a sendkey-request: `./bin/schleuder listname-sendkey@hostname < email`.

Send messages to the list as known: `./bin/schleuder listname@hostname < email`.


## Limitations

Only tested with ruby 2.1 so far.


## TODO

* Tests, Tests, Tests.
* Prefix fingerprint with 0x to force GnuPG to only match fingerprints.
* superadmin-flag for Accounts.
* Highlight unusable keys in keys- and subscription-overview and -detail.
* Edit own subscriptions as non-admin.
* Unsubscribe self as non-admin.
* Button: send key to all subscribed addresses.
* I18n.


See also `rake notes`


## License

GNU GPL version 3.
