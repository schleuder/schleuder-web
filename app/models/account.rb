class Account < ActiveRecord::Base
  has_secure_password
  # Associate through email-addresses because with IDs we'd need an account for
  # every subscription.
  has_many :subscriptions, primary_key: :email, foreign_key: :email
  has_many :lists, through: :subscriptions

  def to_s
    email
  end

  def superadmin?
    self.email == 'root@localhost'
  end

  def admin_lists
    subscriptions.where(admin: true).map(&:list)
  end
end
