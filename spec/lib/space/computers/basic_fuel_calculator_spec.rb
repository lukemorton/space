require_relative '../../../../lib/space/computers/basic_fuel_calculator'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Computers::BasicFuelCalculator do
  let(:ship) { instance_double('Space::Flight::Ship', fuel: Space::Flight::Ship::FUEL_MAX) }
  let(:distance_calculator) { instance_double('Space::Computers::EuclideanDistanceCalculator') }
  let(:current_location) { instance_double('Space::Locations::Location') }
  let(:destination) { instance_double('Space::Locations::Location') }

  subject do
    described_class.new(
      distance_calculator: distance_calculator,
      ship: ship
    )
  end

  it 'returns fuel to travel' do
    expect(subject.fuel_to_travel(destination)).to eq(Space::Flight::Ship::FUEL_TO_TRAVEL)
  end

  it 'returns new fuel level' do
    expect(subject.new_fuel_level(destination)).to eq(ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL)
  end
end
