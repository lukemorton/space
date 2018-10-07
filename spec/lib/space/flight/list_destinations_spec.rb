require_relative '../../../../lib/space/flight/list_destinations'

RSpec.describe Space::Flight::ListDestinations do
  context 'when listing locations' do
    let(:current_location) { instance_double('Space::Locations::Location', id: 1, coordinates: [1, 2, 3], name: 'London') }
    let(:another_location) { instance_double('Space::Locations::Location', id: 2, name: 'Paris', coordinates: [4, 5, 6]) }
    let(:yet_another_location) { instance_double('Space::Locations::Location', id: 2, name: 'Paris', coordinates: [1, 2, 4]) }

    let(:locations) { [current_location, another_location, yet_another_location] }
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', all: locations) }

    subject { described_class.new(location_gateway: location_gateway).list(current_location) }

    it 'should have destinations' do
      expect(subject.destinations).to_not be_empty
    end

    it 'should not include current location in destinations' do
      expect(subject.destinations.map(&:id)).to_not include(current_location.id)
    end
  end
end
