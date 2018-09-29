require_relative '../../../../lib/space/computers/basic_travel_validator'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Computers::BasicTravelValidator do
  let(:current_location) { instance_double('Location', id: 1) }
  let(:destination_location) { instance_double('Location', id: 2) }
  let(:ship) { instance_double('Space::Flight::Ship', id: 1, fuel: Space::Flight::Ship::FUEL_MAX, location: current_location) }
  let(:new_fuel_level) { ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL }
  let(:fuel_calculator) { instance_double('Space::Flight::TravelComputerFactory::FuelCalculator', new_fuel_level: new_fuel_level) }

  subject do
    described_class.new(
      destination_location: destination_location,
      fuel_calculator: fuel_calculator,
      ship: ship
    )
  end

  it 'allows valid travel' do
    expect(subject).to be_valid
  end

  context 'and trying to travel without enough fuel' do
    let(:ship) { instance_double('Space::Flight::Ship', id: 1, fuel: 0, location: current_location) }

    it 'disallows travel' do
      expect(subject).to_not be_valid
    end

    it 'provides an error' do
      subject.valid?
      expect(subject.errors.full_messages).to include('Fuel too low')
    end
  end

  context 'and trying to travel to current station' do
    let(:destination_location) { current_location }

    it 'disallows travel' do
      expect(subject).to_not be_valid
    end

    it 'provides an error' do
      subject.valid?
      expect(subject.errors.full_messages).to include('Destination location is same as current location')
    end
  end
end
