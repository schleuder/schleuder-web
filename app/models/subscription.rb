class Subscription < ActiveRecord::Base
  belongs_to :list

  validates  :list_id, inclusion: { in: List.pluck(:id) }
  validates  :email, presence: true

  default_scope { order(:email) }

  def to_s
    email
  end

  def fingerprint=(arg)
    # Strip whitespace from incoming arg.
    write_attribute(:fingerprint, arg.gsub(/\s*/, '').chomp)
  end

  def account
    Account.find_by(email: self.email)
  end

  def key
    list.keys(self.fingerprint).first
  end

  def send_mail(mail)
    mail.to = self.email
    # TODO: implement attach_incoming
    gpg_opts = {encrypt: true, sign: true, keys: {self.email => self.fingerprint}}
    # TODO: catch unusable-key-errors
    if self.key.blank?
      if self.list.send_encrypted_only?
        $stderr.puts "Not sending to #{self.email}: no key present and sending plain text not allowed"
        return false
      else
        gpg_opts.merge!(encrypt: false)
      end
    end
    mail.gpg gpg_opts
    mail.deliver
  end

end
