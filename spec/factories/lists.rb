FactoryBot.define do
  factory :list do
    email { "list@example.org" }

    trait :with_one_subscription do
      after(:build) do |list|
        create(:subscription)
      end
    end
    factory :list_with_one_subscription, traits: [:with_one_subscription]
  end
end
