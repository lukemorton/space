FactoryBot.define do
  factory :ship do
    id { FactoryBot.generate(:random_id) }
    location

    trait :with_crew do
      after :create do |ship, evaluator|
        create_list(:person, 2, ship: ship, location: ship.location)
      end
    end
  end
end
