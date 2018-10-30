require_relative '../../../../lib/space/flight/ship_gateway'

RSpec.describe Space::Flight::ShipGateway do
  let(:person_record) do
    instance_double('Person', id: 1, name: 'Luke')
  end

  let(:ship_boarding_request_record) do
    instance_double('ShipBoardingRequest', id: 1, requester: person_record)
  end

  let(:dock_record) do
    instance_double('Dock', id: 1, name: 'London Dock', slug: 'london-dock')
  end

  let(:location_record) do
    instance_double('Location', id: 1, coordinate_x: 1, coordinate_y: 2, coordinate_z: 3, name: 'London', slug: 'london')
  end

  let(:ship_record_id) { 1 }
  let(:ship_record_slug) { 'endeavor' }
  let(:ship_record) do
    instance_double(
      'Ship',
      id: ship_record_id,
      boarding_requests: [ship_boarding_request_record],
      crew: [person_record],
      dock: dock_record,
      fuel: 100,
      location: location_record,
      name: 'Endeavour',
      slug: ship_record_slug,
      update: true
    )
  end

  shared_examples 'a ship' do
    it { is_expected.to be_a(Space::Flight::Ship) }

    it 'has id' do
      expect(ship.id).to eq(ship_record_id)
    end

    it 'has fuel' do
      expect(ship.fuel).to eq(ship_record.fuel)
    end

    it 'has name' do
      expect(ship.name).to eq(ship_record.name)
    end

    it 'has slug' do
      expect(ship.slug).to eq(ship_record.slug)
    end

    it 'has computer references' do
      expect(ship.computer_references.distance_calculator).to_not be_empty
      expect(ship.computer_references.fuel_calculator).to_not be_empty
    end

    it 'can generate param from slug' do
      expect(ship.to_param).to eq(ship_record.slug)
    end

    it 'can check if person has requested to board' do
      expect(ship.has_boarding_request_from_person?(person_record.id)).to be(true)
      expect(ship.has_boarding_request_from_person?(0)).to be(false)
    end

    it 'can check if person is in crew' do
      expect(ship.has_crew_member_id?(person_record.id)).to be(true)
      expect(ship.has_crew_member_id?(0)).to be(false)
    end

    it 'has boarding requests' do
      expect(ship.boarding_requests).to_not be_empty
    end

    it 'has boarding requests with requester name' do
      expect(ship.boarding_requests.first.requester.name).to eq('Luke')
    end

    it 'has crew' do
      expect(ship.crew).to_not be_empty
    end

    it 'has crew with id' do
      expect(ship.crew.first.id).to eq(person_record.id)
    end

    it 'has crew with name' do
      expect(ship.crew.first.name).to eq(person_record.name)
    end

    it 'has a dock' do
      expect(ship.dock).to_not be_nil
    end

    it 'has a dock with id' do
      expect(ship.dock.id).to eq(dock_record.id)
    end

    it 'has a dock with name' do
      expect(ship.dock.name).to eq(dock_record.name)
    end

    it 'has a dock with slug' do
      expect(ship.dock.slug).to eq(dock_record.slug)
    end

    it 'can generate dock param from dock slug' do
      expect(ship.dock.to_param).to eq(dock_record.slug)
    end

    it 'has a location' do
      expect(ship.location).to_not be_nil
    end

    it 'has a location with id' do
      expect(ship.location.id).to eq(location_record.id)
    end

    it 'has a location with coordinates' do
      expect(ship.location.coordinates).to eq([
        location_record.coordinate_x,
        location_record.coordinate_y,
        location_record.coordinate_z
      ])
    end

    it 'has a location with name' do
      expect(ship.location.name).to eq(location_record.name)
    end

    it 'has a location with slug' do
      expect(ship.location.slug).to eq(location_record.slug)
    end

    it 'can generate location param from location slug' do
      expect(ship.location.to_param).to eq(location_record.slug)
    end
  end

  context 'when finding a ship by id' do
    let(:ship_repository) do
      class_double('Ship').tap do |double|
        allow(double).to receive(:find_by).with(id: ship_record_id).and_return(ship_record)
      end
    end

    subject(:ship) { described_class.new(ship_repository: ship_repository).find(ship_record_id) }

    it_behaves_like 'a ship'

    context 'and ship does not exist' do
      let(:ship_record) { nil }
      it { is_expected.to be_nil }
    end
  end

  context 'when finding a ship record by slug' do
    let(:ship_repository) do
      class_double('Ship').tap do |double|
        allow(double).to receive(:find_by).with(slug: ship_record_slug).and_return(ship_record)
      end
    end

    subject(:ship) { described_class.new(ship_repository: ship_repository).find_by_slug(ship_record_slug) }

    it_behaves_like 'a ship'

    context 'and ship does not exist' do
      let(:ship_record) { nil }
      it { is_expected.to be_nil }
    end
  end

  context 'when updating a ship record' do
    let(:ship_repository) { class_double('Ship', find: ship_record) }

    subject { described_class.new(ship_repository: ship_repository).update(1, location_id: 2) }

    it { is_expected.to be(true) }

    it 'should find ship by ID' do
      subject
      expect(ship_repository).to have_received(:find).with(1)
    end

    it 'should call update with attrs' do
      subject
      expect(ship_record).to have_received(:update).with(location_id: 2)
    end
  end

  context 'when adding a person to ship crew' do
    let(:crew_member_id) { 1 }
    let(:ship_record) { instance_double('Ship', id: 1, crew_ids: [], dock: nil, location: location_record, update!: true) }
    let(:ship_repository) do
      class_double('Ship').tap do |double|
        allow(double).to receive(:find).with(ship_record.id).and_return(ship_record)
      end
    end

    subject { described_class.new(ship_repository: ship_repository).add_crew_member(ship_record.id, crew_member_id) }

    it { is_expected.to be(true) }

    it 'should update ship with array of crew_ids including person' do
      subject
      expect(ship_record).to have_received(:update!).with(crew_ids: [crew_member_id])
    end
  end

  context 'when removing a crew member from ship' do
    let(:crew_member_id) { 1 }
    let(:crew) { double(:crew, delete: true) }
    let(:ship_record) { instance_double('Ship', id: 1, crew: crew, dock: nil, location: location_record) }
    let(:ship_repository) do
      class_double('Ship').tap do |double|
        allow(double).to receive(:find).with(ship_record.id).and_return(ship_record)
      end
    end

    subject { described_class.new(ship_repository: ship_repository).remove_crew_member(ship_record.id, crew_member_id) }

    it { is_expected.to be(true) }

    it 'should call delete with crew_member_id' do
      subject
      expect(crew).to have_received(:delete).with(crew_member_id)
    end
  end
end
