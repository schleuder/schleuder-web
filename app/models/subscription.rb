class Subscription < Schleuder::Subscription
  def account
    Account.find_by(email: self.email)
  end
end
