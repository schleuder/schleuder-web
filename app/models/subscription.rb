class Subscription < Base
  belongs_to :list

  def to_s
    email
  end

  def key
    Key.find(fingerprint, params: { list_id: self.list_id })
  rescue ActiveResource::ResourceNotFound
    nil
  end

  def account
    Account.find_by(email: self.email)
  end
end
