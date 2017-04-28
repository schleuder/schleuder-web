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

  def expiry_date
    if expiry
      DateTime.parse(expiry)
    else
      expiry
    end
  end
end
