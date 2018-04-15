require_relative '../../../../lib/space/flight/view_controls'

RSpec.describe Space::Flight::ViewControls do
  context 'when viewing flight controls' do
    let(:person) { instance_double('Person', name: 'Luke') }
    let(:ship) { instance_double('Ship', id: 1, crew: [person]) }
    let(:locations) { [double] }

    let(:use_case) do
      described_class.new(
        location_gateway: instance_double('Space::Locations::LocationGateway', all: locations),
        ship_gateway: instance_double('Space::Flight::ShipGateway', find: ship)
      )
    end

    subject { use_case.view(ship.id) }

    it 'should have ship' do
      expect(subject.ship.id).to eq(ship.id)
    end

    it 'should have person' do
      expect(subject.person.name).to eq('Luke')
    end

    it 'should have locations' do
      expect(subject.locations).to_not be_empty
    end
  end
end
