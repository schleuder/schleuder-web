if Rails.env.production? && ENV["SECRET_KEY_BASE"].blank?
  $stderr.puts "Error: The environment variables SECRET_KEY_BASE is empty but required in 'production'. Please set it and try again."
  exit 1
end
