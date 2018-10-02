require_relative '../../../../lib/space/computers/basic_fuel_calculator'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Computers::BasicFuelCalculator do
  let(:ship) { instance_double('Space::Flight::Ship', fuel: Space::Flight::Ship::FUEL_MAX) }

  subject do
    described_class.new(
      ship: ship
    )
  end

  it 'returns fuel to travel' do
    expect(subject.fuel_to_travel).to eq(Space::Flight::Ship::FUEL_TO_TRAVEL)
  end

  it 'returns new fuel level' do
    expect(subject.new_fuel_level).to eq(ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL)
  end
end
