require_relative '../../../../lib/space/flight/ship_gateway'

RSpec.describe Space::Flight::ShipGateway do
  let(:location_record) do
    instance_double(
      'Location',
      id: 1,
      establishments: [],
      name: 'London'
    )
  end

  let(:ship_record) do
    instance_double(
      'Ship',
      id: 1,
      crew: [],
      dock: nil,
      location: location_record,
      update: true
    )
  end

  context 'when finding a ship record' do
    let(:ship_repository) do
      class_double('Ship').tap do |double|
        allow(double).to receive(:find_by).with(id: ship_record.id).and_return(ship_record)
      end
    end

    subject { described_class.new(ship_repository: ship_repository).find(ship_record.id) }

    it { is_expected.to be_a(Space::Flight::Ship) }

    it 'has correct ID' do
      expect(subject.id).to eq(ship_record.id)
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
