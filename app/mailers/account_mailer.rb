class AccountMailer < ActionMailer::Base
  def send_verification_link(email, token)
    link = setup_account_url(token, host: SchleuderConfig.web_hostname)
    mail(
      from: SchleuderConfig.mailer_from,
      to: email,
      subject: "Schleuder account verification",
      body: "To verify the account please put this link into your browser:\n#{link}\n\nSincerely, Schleuder\n"
    )
  end
end
