require 'rails_helper'

describe Conf do
  it "reflects environment-variables" do
    expect(Conf.api_key).to eql("ii123456789ii")
    expect(Conf.api.tls_fingerprint).to eql("6062f05f89384e5f2cda7ab3fc4f5af971d1c524187d90d8e3304e5e0ca6f853")
    expect(Conf.api.host).to eql("localhost")
    expect(Conf.api.port).to eql(4443)

    ENV["SCHLEUDER_API_KEY"] = '123'
    ENV["SCHLEUDER_TLS_FINGERPRINT"] = '456'
    ENV["SCHLEUDER_API_HOST"] = "lala.local"
    ENV["SCHLEUDER_API_PORT"] = '9999'
    Conf.squire.reload!

    expect(Conf.api_key).to eql(123)
    expect(Conf.api.tls_fingerprint).to eql(456)
    expect(Conf.api.host).to eql("lala.local")
    expect(Conf.api.port).to eql(9999)

    # Cleanup
    ENV["SCHLEUDER_API_KEY"] = nil
    ENV["SCHLEUDER_TLS_FINGERPRINT"] = nil
    ENV["SCHLEUDER_API_HOST"] = nil
    ENV["SCHLEUDER_API_PORT"] = nil
    Conf.squire.reload!
  end
end

