if API_REQUIRED

  ActiveSupport::Reloader.to_prepare do
    REQUIRED_API_VERSION = '4.0'

    begin
      found_api_version = Base.api_version
      if Gem::Version.new(found_api_version) < Gem::Version.new(REQUIRED_API_VERSION)
        Rails.logger.error "The version of the running schleuder-api-daemon is too old! This schleuder-web will run into problems if you don't fix that! Required API-version: #{REQUIRED_API_VERSION}. API-version running:  #{found_api_version}."
      end
    rescue Errno::ECONNREFUSED => exc
      Rails.logger.error "schleuder-api-daemon is not running! '#{exc}'. This schleuder-web will be very useless without schleuder-api-daemon!"
    rescue ActiveResource::BadRequest => exc
      Rails.logger.error "schleuder-api-daemon returned HTTP status code 400: '#{exc}'. Please have a look at its output to find out about the causal problem. This schleuder-web will be very useless without schleuder-api-daemon!"
    rescue ActiveResource::UnauthorizedAccess => exc
      Rails.logger.error "Authentication failed with schleuder-api-daemon! Please check that the configured `api_key` is correct (in config/schleuder-web.yml)"
    rescue ActiveResource::SSLError => exc
      if exc.message.include?("certificate verify failed")
        Rails.logger.error "Verifying the certificate of schleuder-api-daemon failed! Please check that the configured `tls_fingerprint` is correct (in config/schleuder-web.yml)."
      else
        Rails.logger.error "An unknow SSL-related error occurred while contacting schleuder-api-daemon: #{exc}"
      end
    rescue StandardError => exc
      Rails.logger.error "An unknown error occurred while contacting schleuder-api-daemon: #{exc}"
    end
  end
end
