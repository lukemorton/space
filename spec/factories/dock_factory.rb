FactoryBot.define do
  factory :dock do
    name { "#{Faker::Zelda.location} Dock" }
    location
  end
end
