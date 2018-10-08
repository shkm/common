FactoryBot.define do
  factory :shop do
    sequence(:shopify_domain) { |n| "shop#{n}" }
    shopify_token { "MyString" }
    plan_name { 'affiliate' }
  end
end
