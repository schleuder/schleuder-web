FactoryBot.define do
  factory :subscription do
    sequence(:email) {|n| "user#{n}@example.org" }
    fingerprint { "129A74AD5317457F9E502844A39C61B32003A8D8" }
    admin { false }
    delivery_enabled { true }
    list_id { 1 }
  end
end
