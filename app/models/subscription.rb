class Subscription < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :list
end
