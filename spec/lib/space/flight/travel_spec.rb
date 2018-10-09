require_relative '../../../../lib/space/flight/travel'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Flight::Travel do
  context 'when travelling from station to station' do
    let(:current_station) { instance_double('Location', id: 1) }
    let(:destination_dock) { instance_double('Dock', id: 1) }
    let(:destination_station) { instance_double('Location', id: 2, establishments: [destination_dock]) }
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find: destination_station) }

    let(:person) { instance_double('Person', id: 1, location: current_station, :location= => nil) }
    let(:person_gateway) { instance_double('Space::Folk::PersonGateway', update: true) }

    let(:ship) { instance_double('Space::Flight::Ship', id: 1, crew: [person], fuel: Space::Flight::Ship::FUEL_MAX, location: current_station) }
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: ship, update: true) }

    let(:new_fuel_level) { ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL }
    let(:fuel_calculator) { instance_double('Space::Flight::TravelComputerFactory::FuelCalculator', new_fuel_level: new_fuel_level) }
    let(:travel_computer_factory) { instance_double('Space::Flight::TravelComputerFactory', create_fuel_calculator: fuel_calculator) }

    let(:use_case) do
      described_class.new(
        location_gateway: location_gateway,
        person_gateway: person_gateway,
        ship_gateway: ship_gateway,
        travel_computer_factory: travel_computer_factory
      )
    end

    subject { use_case.travel(ship.id, to: destination_station.id) }

    it 'allows valid travel' do
      expect(subject).to be_successful
    end

    it 'updates persons location' do
      subject
      expect(person_gateway).to have_received(:update).with(
        person.id,
        location_id: destination_station.id
      )
    end

    it 'uses fuel calculator' do
      subject
      expect(travel_computer_factory).to have_received(:create_fuel_calculator).with(
        ship
      )
    end

    it 'consumes ship fuel' do
      subject
      expect(ship_gateway).to have_received(:update).with(
        ship.id,
        a_hash_including(fuel: new_fuel_level)
      )
    end

    it 'updates ships location' do
      subject
      expect(ship_gateway).to have_received(:update).with(
        ship.id,
        a_hash_including(location_id: destination_station.id)
      )
    end

    it 'updates ships dock' do
      subject
      expect(ship_gateway).to have_received(:update).with(
        ship.id,
        a_hash_including(dock_id: destination_dock.id)
      )
    end

    context 'and no ship found' do
      let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: nil) }

      it 'disallows travel' do
        expect{subject}.to raise_error(Space::Flight::UnknownShipError)
      end
    end

    context 'and no location found' do
      let(:location_gateway) { instance_double('Space::Flight::LocationGateway', find: nil) }

      it 'disallows travel' do
        expect{subject}.to raise_error(Space::Locations::UnknownLocationError)
      end
    end

    context 'and attempting invalid travel' do
      let(:destination_station) { current_station }

      it 'disallows travel' do
        expect{subject}.to raise_error(Space::Flight::InvalidTravelError)
      end
    end
  end
end
