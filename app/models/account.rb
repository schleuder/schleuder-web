class Account < ActiveRecord::Base
  has_secure_password

  def to_s
    email
  end

  def superadmin?
    self.email == 'root@localhost'
  end

  def admin_of?(list)
    admin_lists.include?(list)
  end

  def subscribed_to?(list)
    lists.include?(list)
  end

  def subscriptions
    @subscriptions ||= Subscription.where(email: self.email)
  end

  def lists
    subscriptions.map(&:list)
  end

  def admin_lists
    Subscription.where(email: self.email, admin: true).map(&:list)
  end
end
