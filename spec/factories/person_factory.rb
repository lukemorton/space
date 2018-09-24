FactoryBot.define do
  factory :person do
    id { FactoryBot.generate(:random_id) }
    name { Faker::Zelda.character }
    location
    user

    trait :with_ship do
      ship
      after(:create) do |person|
        person.ship.crew << person
      end
    end
  end
end
