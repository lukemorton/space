require_relative '../../../../lib/space/flight/travel'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Flight::Travel do
  context 'when travelling from station to station' do
    let(:current_station) { instance_double('Location', id: 1) }
    let(:destination_dock) { instance_double('Dock', id: 1) }
    let(:destination_station) { instance_double('Location', id: 1, establishments: [destination_dock]) }
    let(:person) { instance_double('Person', id: 1, location: current_station, :location= => nil) }
    let(:ship) { instance_double('Space::Flight::Ship', id: 1, crew: [person], fuel: Space::Flight::Ship::FUEL_MAX, location: current_station) }
    let(:person_gateway) { instance_double('Space::Flight::PersonGateway', update: true) }
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: ship, update: true) }

    let(:use_case) do
      described_class.new(
        location_gateway: instance_double('Space::Locations::LocationGateway', find: destination_station),
        person_gateway: person_gateway,
        ship_gateway: ship_gateway
      )
    end

    subject { use_case.travel(ship.id, to: destination_station) }

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

    it 'uses ship fuel' do
      subject
      expect(ship_gateway).to have_received(:update).with(
        ship.id,
        a_hash_including(fuel: ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL)
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

    context 'and trying to travel to current station' do
      let(:destination_station) { current_station }

      it 'disallows valid travel' do
        expect(subject).to_not be_successful
      end

      it 'provides an error' do
        expect(subject.errors).to include(:destination_location)
      end
    end
  end
end
