FactoryBot.define do
  factory :ship do
    id { FactoryBot.generate(:random_id) }
    dock
    name { Faker::Space.nasa_space_craft }

    after :build do |ship|
      ship.location = ship.dock.location
    end

    trait :with_crew do
      after :create do |ship, evaluator|
        create_list(:person, 2, ship: ship, location: ship.location)
      end
    end
  end
end
