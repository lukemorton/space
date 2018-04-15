FactoryBot.define do
  factory :ship do
    id { FactoryBot.generate(:random_id) }
    location
  end
end
