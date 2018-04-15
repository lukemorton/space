require_relative '../../../../lib/space/flight/view_controls'

RSpec.describe Space::Flight::ViewControls do
  context 'when viewing flight controls' do
    let(:person) { double(name: 'Luke') }
    let(:locations) { [double] }
    let(:ship_id) { 1 }

    let(:use_case) do
      described_class.new(
        person_gateway: instance_double('Space::Flight::PersonGateway', find: person),
        location_gateway: instance_double('Space::Locations::LocationGateway', all: locations)
      )
    end

    subject { use_case.view(ship_id) }

    it 'should have ship' do
      expect(subject.ship.id).to eq(ship_id)
    end

    it 'should have person' do
      expect(subject.person.name).to eq('Luke')
    end

    it 'should have locations' do
      expect(subject.locations).to_not be_empty
    end
  end
end
