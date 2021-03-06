require_relative '../../../../lib/space/locations/view_current'

RSpec.describe Space::Locations::ViewCurrent do
  let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find_by_slug: nil) }
  let(:person_gateway) { instance_double('Space::Locations::LocationGateway', find: person) }
  let(:location) { instance_double('Space::Locations::Location', id: 1, coordinates: [1, 2, 3], establishments: [], name: 'London', slug: 'london') }
  let(:person) { instance_double('Space::Locations::Person', id: 1, location: location, aboard_ship?: false) }

  let(:use_case) do
    allow(location_gateway).to receive(:find_by_slug).with(location.slug).and_return(location)
    described_class.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end

  context 'when viewing current location' do
    subject { use_case.view(location.slug, person.id) }

    it 'should have name' do
      expect(subject.location.name).to eq(location.name)
    end
  end

  context 'when viewing location other than current' do
    let(:other_location) { instance_double('Space::Locations::Location', id: 2, establishments: [], name: 'London') }
    let(:person) { instance_double('Space::Locations::Person', id: 1, location: other_location, aboard_ship?: false) }

    subject { use_case.view(location.slug, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::PersonNotInLocationError)
    end
  end

  context 'when viewing invalid location' do
    subject { use_case.view(nil, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::UnknownLocationError)
    end
  end

  context 'when person aboard ship' do
    let(:person) { instance_double('Space::Locations::Person', id: 1, location: location, aboard_ship?: true) }

    subject { use_case.view(location.slug, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::PersonAboardShipError)
    end
  end
end
