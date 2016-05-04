class Key < ActiveResource::Base
  self.site = Conf.schleuderd_uri
  self.timeout = 10

  def to_s
    "0x#{fingerprint} <#{email}>"
  end

  def to_param
    fingerprint
  end

  def id
    fingerprint
  end
end
