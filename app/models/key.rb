class Key < Base
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
