class Subscription < ActiveResource::Base
  self.site = Conf.schleuderd_uri

  schema do
    string 'email', 'fingerprint'
    integer 'list_id'
    boolean 'admin', 'delivery_enabled'
  end

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
