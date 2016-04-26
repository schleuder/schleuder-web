class Key < ActiveResource::Base
  self.site = Conf.schleuderd_uri
  self.timeout = 10

  def to_s
    inspect
    #fingerprint
  end

  def to_param
    fingerprint
  end

  def id
    fingerprint
  end
end
