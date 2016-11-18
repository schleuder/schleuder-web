# Monkey-patch OpenSSL to skip checking the hostname of the remote certificate.
# We need to enable VERIFY_PEER in order to get hands on the remote certificate
# to check the fingerprint. But we don't care for the matching of the
# hostnames. Unfortunately this patch is apparently the only way to achieve
# that.
module OpenSSL
  module SSL
    def self.verify_certificate_identity(peer_cert, hostname)
      Rails.logger.debug "Ignoring check for hostname (verify_certificate_identity())."
      true
    end
  end
end
