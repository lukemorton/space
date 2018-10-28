require_relative '../../../../lib/space/locations/view_dock'

RSpec.describe Space::Locations::ViewDock do
  let(:crew_member) do
    instance_double(
      'Space::Locations::Dock::Ship::CrewMember',
      id: 1,
      name: 'Endeavour'
    )
  end

  let(:ship) do
    instance_double(
      'Space::Locations::Dock::Ship',
      id: 1,
      crew: [crew_member],
      name: 'Endeavour',
      slug: 'endeavour',
      to_param: 'endeavour'
    )
  end

  let(:dock_gateway) { instance_double('Space::Locations::DockGateway', find_by_slug: nil) }
  let(:dock) do
    instance_double(
      'Space::Locations::Dock',
      id: 1,
      location: instance_double('Space::Locations::Dock::Location', slug: location.slug),
      name: 'Dock',
      ships: [ship],
      slug: 'dock-at-london'
    )
  end

  let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find_by_slug: nil) }
  let(:location) { instance_double('Space::Locations::Location', id: 1, coordinates: [1, 2, 3], establishments: [], name: 'London', slug: 'london') }

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

    it 'has name' do
      expect(subject.name).to eq('Dock')
    end

    it 'has slug' do
      expect(subject.slug).to eq('dock-at-london')
    end

    it 'has ships' do
      expect(subject.ships).to_not be_empty
    end

    it 'has ships with ids' do
      expect(subject.ships.first.id).to eq(ship.id)
    end

    it 'has ships with names' do
      expect(subject.ships.first.name).to eq(ship.name)
    end

    it 'has ships with slugs' do
      expect(subject.ships.first.slug).to eq(ship.slug)
    end

    it 'has ships with crew' do
      expect(subject.ships.first.crew).to_not be_empty
    end

    it 'has ships with crew id' do
      expect(subject.ships.first.crew.first.id).to eq(crew_member.id)
    end

    it 'has ships with crew names' do
      expect(subject.ships.first.crew.first.name).to eq(crew_member.name)
    end

    it 'generates ship param from slug' do
      expect(subject.ships.first.to_param).to eq(ship.to_param)
    end

    it 'has ships that can have boarding request from current person' do
      expect(subject.ships.first).to_not have_boarding_request_from_current_person
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
