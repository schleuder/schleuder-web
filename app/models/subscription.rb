class Subscription < ActiveResource::Base
  self.site = 'http://localhost:4567/'
  schema do
    string 'email', 'fingerprint'
    integer 'list_id'
    boolean 'admin', 'delivery_disabled'
  end

  belongs_to :list

  def key
    Key.find(fingerprint, params: { list_id: self.list_id })
  rescue ActiveResource::ResourceNotFound
    nil
  end

  def account
    Account.find_by(email: self.email)
  end
end
