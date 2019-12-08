require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SchleuderWeb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Will forms each have their own CSRF token that is specific to the action
    # and method for that form?
    config.action_controller.per_form_csrf_tokens = true

    # Check if the HTTP Origin header should be checked against the site's
    # origin as an additional CSRF defense.
    config.action_controller.forgery_protection_origin_check = true

    require 'openssl'
    require 'mail'

    require 'bcrypt'
    require 'active_resource'
    require 'haml-rails'
    require 'sass-rails'
    require 'bootstrap-sass'
    require 'simple_form'
    require 'squire'
    require 'cancancan'
  end
end
