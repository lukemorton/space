require_relative '../../../../lib/space/locations/location_gateway'

RSpec.describe Space::Locations::LocationGateway do
  let(:location_record_id) { 1 }
  let(:location_record) do
    instance_double(
      'Location',
      id: location_record_id,
      establishments: [],
      name: 'Cool'
    )
  end

  context 'when finding all location record' do
    let(:location_records) { [location_record] }
    let(:location_repository) { class_double('Location', all: double(includes: location_records)) }

    subject { described_class.new(location_repository: location_repository).all }

    it { is_expected.to include(a_kind_of(Space::Locations::Location)) }
  end

  context 'when finding a location record' do
    let(:location_repository) do
      class_double('Location').tap do |double|
        allow(double).to receive(:find_by).with(id: location_record_id).and_return(location_record)
      end
    end

    subject { described_class.new(location_repository: location_repository).find(location_record_id) }

    it { is_expected.to be_a(Space::Locations::Location) }

    context 'and location does not exist' do
      let(:location_record) { nil }
      it { is_expected.to be_nil }
    end
  end
end
