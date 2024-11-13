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

def api_uri_with_path(path)
  URI.join(Conf.api_uri, path)
end

def read_fixture(file)
  File.read(File.join(fixture_paths, file))
end

def json_object_as_array(file)
  [JSON.parse(read_fixture(file))].to_json
end

require 'webmock/rspec'
WebMock.disable_net_connect!
