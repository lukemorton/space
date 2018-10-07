require_relative '../../../../lib/space/flight/list_destinations'

RSpec.describe Space::Flight::ListDestinations do
  context 'when listing locations' do
    let(:distance_calculator) { instance_double('Space::Computers::EudclideanDistanceCalculator', distance_between: 10) }
    let(:fuel_calculator) { instance_double('Space::Computers::BasicFuelCalculator', name: 'A', description: 'B', fuel_to_travel: 10, new_fuel_level: 90) }

    let(:current_location) { instance_double('Space::Locations::Location', id: 1, coordinates: [1, 2, 3], name: 'London') }
    let(:another_location) { instance_double('Space::Locations::Location', id: 2, name: 'Paris', coordinates: [4, 5, 6]) }
    let(:yet_another_location) { instance_double('Space::Locations::Location', id: 2, name: 'Paris', coordinates: [1, 2, 4]) }

    let(:locations) { [current_location, another_location, yet_another_location] }
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', all: locations) }

    let(:list_destinations_use_case) do
      described_class.new(
        distance_calculator: distance_calculator,
        fuel_calculator: fuel_calculator,
        location_gateway: location_gateway
      )
    end

    subject { list_destinations_use_case.list(current_location) }

    it 'should have destinations' do
      expect(subject.destinations).to_not be_empty
    end

    it 'should not include current location in destinations' do
      expect(subject.destinations.map(&:id)).to_not include(current_location.id)
    end

    it 'should order destinations by fuel ascending' do
      expect(fuel_calculator).to receive(:fuel_to_travel).and_return(12, 10)
      expect(subject.destinations.first.fuel_to_travel).to be < subject.destinations.last.fuel_to_travel
    end

    context 'a destination' do
      subject { list_destinations_use_case.list(current_location).destinations.first }

      it 'has id' do
        expect(subject.id).to eq(another_location.id)
      end

      it 'has coordinates' do
        expect(subject.coordinates).to eq(another_location.coordinates)
      end

      it 'has distance' do
        expect(subject.distance).to eq(10)
      end

      it 'has name' do
        expect(subject.name).to eq(another_location.name)
      end

      it 'has fuel to travel' do
        expect(subject.fuel_to_travel).to eq(10)
      end

      it 'can be within ship fuel range' do
        expect(subject).to be_within_ship_fuel_range
      end

      it 'can be just within ship fuel range' do
        expect(subject).to be_just_within_ship_fuel_range
      end

      context 'and ship out of fuel' do
        let(:fuel_calculator) { instance_double('Space::Flight::TravelComputerFactory::FuelCalculator', name: 'A', description: 'B', fuel_to_travel: 10, new_fuel_level: -10) }

        it 'should not have enough fuel to reach destination' do
          expect(subject).to_not be_within_ship_fuel_range
        end
      end

      context 'and ship almost out of fuel' do
        let(:fuel_calculator) { instance_double('Space::Flight::TravelComputerFactory::FuelCalculator', name: 'A', description: 'B', fuel_to_travel: 10, new_fuel_level:  0) }

        it 'should just about have enough fuel to reach destination' do
          expect(subject).to be_within_ship_fuel_range
          expect(subject).to be_just_within_ship_fuel_range
        end
      end
    end
  end
end
