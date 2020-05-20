SecureHeaders::Configuration.default do |config|
  config.cookies = {
    samesite: {
      strict: true
    }
  }
end
