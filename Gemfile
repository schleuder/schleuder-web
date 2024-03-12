source 'https://rubygems.org'

gem 'rake'
gem 'bootsnap', '~> 1.18'
gem 'rails', '~> 7.1.0'
gem 'bcrypt', '~> 3.1'
gem 'haml-rails', '~> 2.1.0'
gem 'sass-rails', '~>  6.0'
gem 'bootstrap-sass', '~> 3.3'
gem 'simple_form', '~> 5.0'
gem 'squire', '~> 1.3'
gem 'cancancan', '~> 3.5'
gem 'sqlite3', '~> 1.6.0'
gem 'thin', '~> 1.8'
gem "activeresource-response", '~> 1.4'
gem "secure_headers", "~> 6.5"

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
  gem 'capybara', '~> 3.39.0'
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1.0')
    # This is a dependency of capybara, which got extracted from the stdlib since Ruby 3.1, but is only `required` by capybara in a version we can't pin because it requires Ruby >= v3.0, and we still support v2.7.
    gem 'matrix', '~> 0.4.2'
  end
  gem 'factory_bot_rails', '~> 6.4'
  gem 'webmock', '~> 3.23'
  gem 'sinatra', '~> 3.0'
  # gem 'launchy'
end

Dir['Gemfile.local*'].each do |file|
  eval_gemfile file
end
