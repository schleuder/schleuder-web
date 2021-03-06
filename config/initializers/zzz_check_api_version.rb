if API_REQUIRED

  REQUIRED_API_VERSION = '4.0'

  begin
    found_api_version = Base.api_version
    if Gem::Version.new(found_api_version) < Gem::Version.new(REQUIRED_API_VERSION)
      $stderr.puts "
        WARNING!
        WARNING! The version of the running schleuder-api-daemon is too old!
        WARNING!
        WARNING! This schleuder-web will run into problems if you don't fix that!
        WARNING! Required API-version: #{REQUIRED_API_VERSION}
        WARNING! API-version running:  #{found_api_version}
        WARNING!
        ".gsub(/^\s*/, '')
    end

  rescue Errno::ECONNREFUSED => exc
      $stderr.puts "
        WARNING!
        WARNING! schleuder-api-daemon is not running!
        WARNING! '#{exc}'
        WARNING!
        WARNING! This schleuder-web will be very useless without schleuder-api-daemon!
        WARNING!
        ".gsub(/^\s*/, '')

  rescue ActiveResource::BadRequest => exc
      $stderr.puts "
        WARNING!
        WARNING! schleuder-api-daemon returned HTTP status code 400.
        WARNING! '#{exc}'
        WARNING!
        WARNING! Please have a look at its output to find out about the causal problem.
        WARNING!
        WARNING! This schleuder-web will be very useless without schleuder-api-daemon!
        WARNING!
        ".gsub(/^\s*/, '')

  rescue StandardError => exc
      $stderr.puts "
        WARNING!
        WARNING! An error occurred while contacting schleuder-api-daemon:
        WARNING! '#{exc}'
        WARNING!
        ".gsub(/^\s*/, '')

  end
end
