require_relative '../../../../lib/space/locations/list'

RSpec.describe Space::Locations::List do
  context 'when listing locations' do
    let(:locations) { [instance_double('Space::Locations::Location', id: 1, coordinates: [1, 2, 3], name: 'London')] }
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', all: locations) }

    subject { described_class.new(location_gateway: location_gateway).list }

    it 'should have locations' do
      expect(subject.locations).to_not be_empty
    end
  end
end
