class Key < ActiveResource::Base
  self.site = Conf.schleuderd_uri

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
