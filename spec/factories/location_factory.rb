FactoryBot.define do
  factory :location do
    id { FactoryBot.generate(:random_id) }
    name { Faker::Zelda.location }
    coordinate_x { Faker::Number.between(1, 100) }
    coordinate_y { Faker::Number.between(1, 100) }
    coordinate_z { Faker::Number.between(1, 100) }

    after(:create) do |location|
      create(:dock, location: location)
    end
  end
end
