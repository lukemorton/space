require_relative '../../../../lib/space/computers/basic_fuel_calculator'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Computers::BasicFuelCalculator do
  let(:current_location) { instance_double('Space::Locations::Location') }
  let(:destination) { instance_double('Space::Locations::Location') }
  let(:ship) { instance_double('Space::Flight::Ship', fuel: Space::Flight::Ship::FUEL_MAX, location: current_location) }
  let(:distance_calculator) { instance_double('Space::Computers::EuclideanDistanceCalculator', distance_between: 5) }

  subject do
    described_class.new(
      distance_calculator: distance_calculator,
      ship: ship
    )
  end

  it 'returns fuel to travel' do
    expected_fuel_to_travel = (5 * Space::Flight::Ship::FUEL_TO_TRAVEL).to_i
    expect(subject.fuel_to_travel(destination)).to eq(expected_fuel_to_travel)
  end

  it 'returns new fuel level' do
    expected_fuel_to_travel = (5 * Space::Flight::Ship::FUEL_TO_TRAVEL).to_i
    expect(subject.new_fuel_level(destination)).to eq(ship.fuel - expected_fuel_to_travel)
  end
end
