class Base < ActiveResource::Base
  self.timeout = 10
  self.site = Conf.api_uri
  self.user = 'schleuder'
  self.password = Conf.api_key
  self.ssl_options = {
    verify_mode: OpenSSL::SSL::VERIFY_PEER,
    verify_callback: lambda { |*a| self.ssl_verify_callback(*a) }
    #ca_file: Conf.api_cert_file
  }
  if Net::HTTP::SSL_ATTRIBUTES.include?(:verify_hostname)
    self.ssl_options[:verify_hostname] = false
  end
  # A little hack to enable requesting URLs from the root of the API (e.g.
  # </version.json> — actually <//version.json> is requested, but
  # schleuder-api-daemon is ok with that).
  self.element_name = ""

  def self.ssl_verify_callback(pre_ok, cert_store)
    cert = cert_store.chain[0]
    # Only really compare if we're looking at the last cert in the chain.
    if cert.to_der != cert_store.current_cert.to_der
      return true
    end
    fingerprint = OpenSSL::Digest::SHA256.new(cert.to_der).to_s
    fingerprint == Conf.api.tls_fingerprint
  end

  def self.api_version
    get(:version)["version"]
  end
end
