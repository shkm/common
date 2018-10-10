FactoryBot.define do
  factory :shop do
    sequence(:shopify_domain) { |n| "shop#{n}" }
    shopify_token { "MyString" }
    plan_name { 'affiliate' }
    uninstalled { false }

    trait :uninstalled do
      uninstalled { true }
    end
  end
end
