class AccountRequest < ActiveRecord::Base
  after_initialize :set_token

  def set_token
    self.token ||= Digest::SHA1.hexdigest(Time.now.to_s + rand.to_s)
  end

  def still_valid?
    (self.created_at + 3.hours) > Time.now
  end
end
