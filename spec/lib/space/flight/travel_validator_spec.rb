require_relative '../../../../lib/space/flight/travel_validator'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Flight::TravelValidator do
  let(:current_location) { instance_double('Location', id: 1) }
  let(:destination_location) { instance_double('Location', id: 2) }
  let(:ship) { instance_double('Space::Flight::Ship', id: 1, fuel: Space::Flight::Ship::FUEL_MAX, has_crew_member_id?: true, location: current_location) }
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
    let(:ship) { instance_double('Space::Flight::Ship', id: 1, fuel: 0, has_crew_member_id?: true, location: current_location) }

    it 'disallows travel' do
      expect(subject).to_not be_valid
    end

    it 'provides an error' do
      subject.valid?
      expect(subject.errors.keys).to include(:fuel)
    end
  end

  context 'and trying to travel to current station' do
    let(:destination_location) { current_location }

    it 'disallows travel' do
      expect(subject).to_not be_valid
    end

    it 'provides an error' do
      subject.valid?
      expect(subject.errors.keys).to include(:destination_location)
    end
  end

  context 'and person not in crew' do
    let(:ship) { instance_double('Space::Flight::Ship', id: 1, crew: [], fuel: Space::Flight::Ship::FUEL_MAX, has_crew_member_id?: false, location: current_location) }

    it 'disallows travel' do
      expect(subject).to_not be_valid
    end

    it 'disallows travel' do
      subject.valid?
      expect(subject.errors.keys).to include(:you)
    end
  end
end
