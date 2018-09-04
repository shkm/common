FactoryBot.define do
  factory :shop do
    sequence(:shopify_domain) { |n| "shop#{n}" }
    shopify_token { "MyString" }
  end
end
