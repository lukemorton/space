FactoryBot.define do
  factory :ship do
    id { FactoryBot.generate(:random_id) }
    location

    after(:create) do |ship, evaluator|
      unless evaluator.crew.empty?
        create_list(:person, 2, ship: ship, location: ship.location)
      end
    end
  end
end
