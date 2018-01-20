# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

require 'webmock/rspec'
WebMock.disable_net_connect!

def log_in_as_super_admin
  user = create(:account, email: 'root@localhost', password: 'password')
  session[:cookietest] = true
  session[:current_account_id] = user.id
  session[:login_expires_at] = 30.minutes.from_now.to_s
end

def log_out
  session.clear
end
