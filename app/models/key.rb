class Key < ActiveResource::Base
  self.site = 'http://localhost:4567/'

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
