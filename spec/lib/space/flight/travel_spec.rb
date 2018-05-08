require_relative '../../../../lib/space/flight/travel'

RSpec.describe Space::Flight::Travel do
  context 'when travelling from station to station' do
    let(:current_station) { instance_double('Location') }
    let(:destination_dock) { instance_double('Dock') }
    let(:destination_station) { instance_double('Location', establishments: [destination_dock]) }
    let(:person) { instance_double('Person', location: current_station, :location= => nil) }
    let(:ship) { instance_double('Ship', id: 1, crew: [person], location: current_station, :location= => nil, :dock= => nil) }

    let(:use_case) do
      described_class.new(
        location_gateway: instance_double('Space::Locations::LocationGateway', find: destination_station),
        person_gateway: instance_double('Space::Flight::PersonGateway', update: true),
        ship_gateway: instance_double('Space::Flight::ShipGateway', find: ship, update: true)
      )
    end

    subject { use_case.travel(ship.id, to: destination_station) }

    it 'allows valid travel' do
      expect(subject).to be_successful
    end

    it 'updates persons location' do
      subject
      expect(person).to have_received(:location=).with(destination_station)
    end

    it 'updates ships location' do
      subject
      expect(ship).to have_received(:location=).with(destination_station)
    end

    it 'updates ships dock' do
      subject
      expect(ship).to have_received(:dock=).with(destination_dock)
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
