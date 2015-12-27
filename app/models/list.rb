class List < ActiveResource::Base
  self.site = Conf.schleuderd_uri
  has_many :subscriptions

  schema do
    boolean 'send_encrypted_only'
  end

  def to_s
    email
  end

  def keys(fingerprint=nil)
    params = {params: { list_id: self.id}}
    if fingerprint.present?
      Key.find(fingerprint, params)
    else
      Key.all(params)
    end
  end

  def key
    Key.find(fingerprint, params: { list_id: self.id })
  end

  def headers_to_meta
    @headers_to_meta ||= attributes['headers_to_meta'].join("\n")
  end

  def bounces_drop_on_headers
    @bounces_drop_on_headers ||= attributes['bounces_drop_on_headers'].attributes.map do |k,v|
      "#{k}: #{v}"
    end.join("\n")
  end
end
