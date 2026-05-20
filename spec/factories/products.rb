FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 8) }
    sequence(:sku) { |n| "#{Faker::Alphanumeric.alphanumeric(number: 6).upcase}-#{n}" }
    price { Faker::Commerce.price(range: 1.0..120.0) }
    stock_quantity { Faker::Number.between(from: 1, to: 80) }
    category { %w[Alimentos Limpeza Bebidas].sample }
  end
end
