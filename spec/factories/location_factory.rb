FactoryBot.define do
  factory :location do
    id { FactoryBot.generate(:random_id) }
    name 'London'
  end
end
