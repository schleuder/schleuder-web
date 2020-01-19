class List < Base
  has_many :subscriptions
  add_response_method :http_response

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
    @key ||= Key.find(fingerprint, params: { list_id: self.id })
  rescue ActiveResource::ResourceNotFound
    nil
  end

  def headers_to_meta
    @headers_to_meta ||= Array(attributes['headers_to_meta']).join("\n")
  end

  def bounces_drop_on_headers
    Rails.logger.info "bdoh: #{attributes['bounces_drop_on_headers'].inspect}"
    @bounces_drop_on_headers ||= Hash(attributes['bounces_drop_on_headers'].attributes).map do |k,v|
      "#{k}: #{v}"
    end.join("\n")
  end

  def admins
    subscriptions.select do |subscription|
      subscription.admin?
    end
  end
end
