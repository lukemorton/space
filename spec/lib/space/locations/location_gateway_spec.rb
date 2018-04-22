require_relative '../../../../lib/space/locations/location_gateway'

RSpec.describe Space::Locations::LocationGateway do
  context 'when finding all location record' do
    let(:location_records) { [instance_double('Location')] }
    let(:location_repository) { class_double('Location', all: location_records) }

    subject { described_class.new(location_repository: location_repository).all }

    it { is_expected.to be(location_records) }
  end

  context 'when finding a location record' do
    let(:location_record) { instance_double('Location', id: 1) }

    let(:location_repository) do
      class_double('Location').tap do |double|
        allow(double).to receive(:find_by).with(id: location_record.id).and_return(location_record)
      end
    end

    subject { described_class.new(location_repository: location_repository).find(location_record.id) }

    it { is_expected.to be(location_record) }
  end
end
