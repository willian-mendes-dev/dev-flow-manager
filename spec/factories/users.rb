FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "usuario_#{n}" }
    password { "Senha@123" }
    password_confirmation { "Senha@123" }
  end
end
