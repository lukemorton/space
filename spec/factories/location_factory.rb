FactoryBot.define do
  factory :location do
    id { FactoryBot.generate(:random_id) }
    name { Faker::Zelda.location }

    after(:create) do |location|
      create(:dock, location: location)
    end
  end
end
