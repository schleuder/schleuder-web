FactoryBot.define do
  factory :account do
    sequence(:email) {|n| "user#{n}@example.org" }
    password { "password" }
  end
end
