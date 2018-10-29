require_relative '../../lib/space/flight/ship'

FactoryBot.define do
  factory :ship_boarding_request do
    id { FactoryBot.generate(:random_id) }
    ship
  end
end
