Product.destroy_all

20.times do
  Product.create! name: Faker::Commerce.product_name,
    price_in_cents: Faker::Commerce.price * 100,
    description: Faker::Lorem.paragraph
end

