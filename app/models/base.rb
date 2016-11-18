require 'schleuder_cert_manager'
require 'openssl_ssl_patch'

class Base < ActiveResource::Base
  self.timeout = 10
  self.site = Conf.schleuderd_uri
  self.user = 'schleuder'
  self.password = Conf.api_key
  self.ssl_options = {
    verify_callback: lambda { |*a| self.ssl_verify_callback(*a) }
    #ca_file: Conf.schleuderd_cert_file
  }

  def self.ssl_verify_callback(pre_ok, cert_store)
    cert = cert_store.chain[0]
    # Only really compare if we're looking at the last cert in the chain.
    if cert.to_der != cert_store.current_cert.to_der
      return true
    end
    fingerprint = OpenSSL::Digest::SHA256.new(cert.to_der).to_s
    fingerprint == Conf.schleuderd.tls_fingerprint
  end
end
