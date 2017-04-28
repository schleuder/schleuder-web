Rails.application.configure do
  config.action_mailer.delivery_method = Conf.delivery_method.to_sym
  # Assign only the appropriate settings, assigning the others breaks delivery.
  case Conf.delivery_method.to_sym
  when :smtp
    config.action_mailer.smtp_settings = Conf.smtp_settings.to_hash
  when :sendmail
    config.action_mailer.sendmail_settings = Conf.sendmail_settings.to_hash
  when :file
    config.action_mailer.file_settings = Conf.file_settings.to_hash
  end
  config.action_mailer.raise_delivery_errors = true
end
