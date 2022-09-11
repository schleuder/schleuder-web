source 'https://rubygems.org'

gem 'rake'
gem 'rails', '~> 7.0', '>= 6.1.2.1'
gem 'bootsnap', '~> 1.13.0'
gem 'bcrypt', '~> 3.1'
gem 'haml-rails', '~> 2.0.0'
gem 'sass-rails', '~>  5.0'
gem 'bootstrap-sass', '~> 3.3'
gem 'simple_form', '~> 5.0.0'
gem 'squire', '~> 1.3'
gem 'cancancan', '~> 3.2.0'
gem 'sqlite3', '~> 1.4.0'
gem 'thin'
gem "activeresource-response"
gem "secure_headers", "~> 6.3"

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3')
  gem 'net-http', require: false
end

group :development do
  gem 'spring'
  gem 'byebug'
  gem 'listen'
  gem 'irb'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'capybara', '~> 3.35.0'
  gem 'factory_bot_rails', '~> 5.1'
  gem 'webmock'
  gem 'sinatra'
  gem 'launchy'
end
