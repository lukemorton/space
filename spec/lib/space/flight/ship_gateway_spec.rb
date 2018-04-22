require_relative '../../../../lib/space/flight/person_gateway'

RSpec.describe Space::Flight::ShipGateway do
  context 'when finding a ship record' do
    let(:ship_record) { instance_double('Ship', id: 1) }
    let(:ship_repository) do
      class_double('Ship').tap do |double|
        allow(double).to receive(:find_by).with(id: ship_record.id).and_return(ship_record)
      end
    end

    subject { described_class.new(ship_repository: ship_repository).find(ship_record.id) }

    it { is_expected.to be(ship_record) }
  end

  context 'when updating a ship record' do
    let(:ship_repository) { class_double('Ship') }
    let(:ship) { instance_double('Ship', save!: true) }

    subject { described_class.new(ship_repository: ship_repository).update(ship) }

    it { is_expected.to be(true) }
  end
end
