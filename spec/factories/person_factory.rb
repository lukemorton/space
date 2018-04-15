FactoryBot.define do
  factory :person do
    id { FactoryBot.generate(:random_id) }
    name 'Cool'
    location
    ship
  end
end
