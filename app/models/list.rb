class List < ActiveRecord::Base
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions

  serialize :headers_to_meta, JSON
  serialize :bounces_drop_on_headers, JSON
  serialize :keywords_admin_only, JSON
  serialize :keywords_admin_notify, JSON

  def admins
    subscriptions.where(admin: true).map(&:subscriber)
  end
end
