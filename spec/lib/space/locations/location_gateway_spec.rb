require_relative '../../../../lib/space/locations/location_gateway'

RSpec.describe Space::Locations::LocationGateway do
  context 'when finding all location record' do
    let(:location_records) { [instance_double('Location')] }
    let(:location_repository) { class_double('Location', all: location_records) }

    subject { described_class.new(location_repository: location_repository).all }

    it { is_expected.to be(location_records) }
  end
end
