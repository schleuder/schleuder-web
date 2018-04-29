# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'support/fake_schleuder_api_daemon'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.before(:each) do
    stub_request(:any, /localhost:4443/).to_rack(FakeSchleuderApiDaemon)
  end

  # Add FactoryBots syntax methods
  config.include FactoryBot::Syntax::Methods
end

def sign_in(user)
  visit new_login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
end
