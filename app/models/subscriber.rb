class Subscriber < ActiveRecord::Base
  has_secure_password
  has_many :subscriptions, dependent: :destroy
  has_many :lists, through: :subscriptions
end
