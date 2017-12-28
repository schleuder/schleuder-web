class Account < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true, email: true
  before_save { email.downcase! }

  def to_s
    email
  end

  def superadmin?
    self.email == 'root@localhost'
  end

  def subscribed_to?(list)
    lists.include?(list)
  end

  def subscriptions
    @subscriptions ||= Subscription.where(email: self.email)
  end

  def subscription(list)
    Subscription.where(email: self.email, list_id: list.id).first
  end

  def lists
    subscriptions.map(&:list)
  end

  def admin_lists
    Subscription.where(email: self.email, admin: true).map(&:list)
  end
end
