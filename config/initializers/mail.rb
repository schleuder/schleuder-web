Rails.application.configure do
  config.action_mailer.delivery_method = Conf.delivery_method
  config.action_mailer.smtp_settings = Conf.smtp_settings
  config.action_mailer.sendmail_settings = Conf.sendmail_settings
  config.action_mailer.raise_delivery_errors = true
end

