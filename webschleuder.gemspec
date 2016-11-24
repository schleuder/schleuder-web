# encoding: utf-8

Gem::Specification.new do |s|
  s.name         = "schleuder-web"
  s.version      = '3.0.0.beta1'
  s.authors      = %w(paz)
  s.email        = "schleuder2@nadir.org"
  s.homepage     = "http://schleuder.nadir.org/"
  s.summary      = "A web frontend for schleuder."
  s.description  = "A web frontend to manage schleuder-lists and -subscriptions, usable for admins and users."
  s.files        = `git ls-files app lib config public etc db/schema.rb README.md Rakefile`.split
  s.executables =  `git ls-files bin`.split.map {|file| File.basename(file) }
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  # TODO: extend/replace expired cert
  #s.signing_key = "#{ENV['HOME']}/.gem/schleuder-gem-private_key.pem"
  #s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'GPL-3'
  s.add_runtime_dependency 'rails', '~> 4.2'
  s.add_runtime_dependency 'bcrypt', '~> 3.1'
  s.add_runtime_dependency 'activeresource', '~> 4.0'
  s.add_runtime_dependency 'haml-rails', '~> 0.9'
  s.add_runtime_dependency 'sass-rails', '~> 5.0'
  s.add_runtime_dependency 'bootstrap-sass', '~> 3.3'
  s.add_runtime_dependency 'simple_form', '~> 3.2'
  s.add_runtime_dependency 'squire', '~> 1.3'
  s.add_runtime_dependency 'cancancan', '~> 1.9'
end
