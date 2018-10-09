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

    trait :with_bank do
      after(:create) do |person|
        person_domain = Space::Folk::Person.from_object(person)
        Space::Folk::MoneyGateway.new(double_entry: DoubleEntry).initialize_bank(person_domain)
      end
    end
  end
end
