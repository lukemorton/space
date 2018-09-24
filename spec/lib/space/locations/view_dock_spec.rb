require_relative '../../../../lib/space/locations/view_dock'

RSpec.describe Space::Locations::ViewDock do
  let(:dock_gateway) { instance_double('Space::Locations::DockGateway', find_by_slug: nil) }
  let(:dock) do
    instance_double(
      'Space::Locations::Dock',
      id: 1,
      location: instance_double('Space::Locations::Dock::Location', slug: location.slug),
      name: 'Dock',
      ships: [],
      slug: 'dock-at-london'
    )
  end

  let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find_by_slug: nil) }
  let(:location) { instance_double('Space::Locations::Location', id: 1, establishments: [], name: 'London', slug: 'london') }

  let(:person_gateway) { instance_double('Space::Locations::LocationGateway', find: person) }
  let(:person) { instance_double('Space::Locations::Person', id: 1, location: location, aboard_ship?: false) }

  let(:use_case) do
    allow(dock_gateway).to receive(:find_by_slug).with(dock.slug).and_return(dock)
    allow(location_gateway).to receive(:find_by_slug).with(location.slug).and_return(location)

    described_class.new(
      dock_gateway: dock_gateway,
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end

  context 'when viewing current dock' do
    subject { use_case.view(dock.slug, person.id) }

    it 'should have name' do
      expect(subject.name).to eq('Dock')
    end
  end

  context 'when viewing dock in another location' do
    let(:other_location) { instance_double('Location', id: 2, establishments: [], name: 'London') }
    let(:person) { instance_double('Space::Locations::Person', id: 1, location: other_location, aboard_ship?: false) }

    subject { use_case.view(dock.slug, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::PersonNotInLocationError)
    end
  end

  context 'when person aboard ship' do
    let(:person) { instance_double('Space::Locations::Person', id: 1, location: location, aboard_ship?: true) }

      subject { use_case.view(dock.slug, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::PersonAboardShipError)
    end
  end

  context 'when viewing invalid dock' do
    subject { use_case.view(nil, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::UnknownDockError)
    end
  end
end
