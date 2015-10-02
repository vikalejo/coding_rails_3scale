FactoryGirl.define do
  factory :product do
    name Faker::Commerce.product_name
    price_in_cents Faker::Commerce.price * 100
    description Faker::Lorem.paragraph
  end
end
