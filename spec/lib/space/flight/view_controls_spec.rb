require_relative '../../../../lib/space/flight/view_controls'

RSpec.describe Space::Flight::ViewControls do
  let(:use_case) do
    ship_gateway = instance_double('Space::Flight::ShipGateway', find: nil).tap do |double|
      allow(double).to receive(:find).with(ship.id).and_return(ship)
    end

    described_class.new(
      location_gateway: instance_double('Space::Locations::LocationGateway', all: locations),
      person_gateway: instance_double('Space::Locations::PersonGateway', find: person),
      ship_gateway: ship_gateway
    )
  end

  context 'when viewing flight controls' do
    let(:person) { instance_double('Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Ship', id: 1, crew_ids: [person.id]) }
    let(:locations) { [instance_double('Location', id: 1, name: 'London')] }

    subject { use_case.view(ship.id, person.id) }

    it { is_expected.to be_person_in_crew }

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

  context 'when not in crew' do
    let(:person) { instance_double('Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Ship', id: 1, crew_ids: []) }
    let(:locations) { [instance_double('Location', id: 1, name: 'London')] }

    subject { use_case.view(ship.id, person.id) }


    it { is_expected.to_not be_person_in_crew }
  end

  context 'when ship unknown' do
    let(:person) { instance_double('Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Ship', id: 1, crew_ids: []) }
    let(:locations) { [instance_double('Location', id: 1, name: 'London')] }

    subject { use_case.view(nil, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Flight::UnknownShipError)
    end
  end
end
