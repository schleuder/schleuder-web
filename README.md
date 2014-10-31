# Webschleuder, a web interface for Schleuder3

This is full features web interface to administrate Schleuder3-lists and subscriptions.
group-gateway.

##  Installation

1. `bundle install`.
1. Optional: edit config/database.yml.
1. Optional: edit config/schleuder.yml.
1. `bundle exec rake db:setup`.


## Usage

1. `bundle exec rails server`
1. Log into the webinterface with email root@localhost and password "slingit!".


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
