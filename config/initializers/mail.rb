Rails.application.configure do
  config.action_mailer.delivery_method = Conf.delivery_method.to_sym
  config.action_mailer.smtp_settings = Conf.smtp_settings.to_hash
  config.action_mailer.sendmail_settings = Conf.sendmail_settings.to_hash
  config.action_mailer.raise_delivery_errors = true
end
