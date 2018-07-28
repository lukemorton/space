FactoryBot.define do
  factory :dock do
    name { Faker::Zelda.location }
    location
  end
end
