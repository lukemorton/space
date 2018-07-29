FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Company.bs }
  end
end
