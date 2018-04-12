require_relative '../../../../lib/space/flight/view_controls'

RSpec.describe Space::Flight::ViewControls do
  context 'when viewing flight controls' do
    let(:person) { double(name: 'Luke') }
    let(:person_gateway) { instance_double('Space::Flight::PersonGateway', find: person) }

    let(:locations) { [double] }
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', all: locations) }

    subject { described_class.new(person_gateway: person_gateway, location_gateway: location_gateway).view(1) }

    it 'should have person' do
      expect(subject.person.name).to eq('Luke')
    end

    it 'should have locations' do
      expect(subject.locations).to_not be_empty
    end
  end
end
