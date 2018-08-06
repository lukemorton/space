require_relative '../../../../lib/space/locations/location_gateway'

RSpec.describe Space::Locations::LocationGateway do
  let(:dock_record) do
    instance_double('Dock', id: 1, name: 'London Dock', slug: 'london-dock')
  end

  let(:location_record_id) { 1 }
  let(:location_record_slug) { 'London' }
  let(:location_record) do
    instance_double(
      'Location',
      id: location_record_id,
      establishments: [dock_record],
      name: 'London',
      slug: location_record_slug
    )
  end

  shared_examples 'a location' do
    it { is_expected.to be_a(Space::Locations::Location) }

    it 'has an id' do
      expect(location.id).to eq(location_record.id)
    end

    it 'has establishements' do
      expect(location.establishments.first.name).to eq(dock_record.name)
    end

    it 'has an name' do
      expect(location.name).to eq(location_record.name)
    end

    it 'has an slug' do
      expect(location.slug).to eq(location_record.slug)
    end

    it 'generates param from slug' do
      expect(location.to_param).to eq(location_record.slug)
    end
  end

  context 'when finding all location record' do
    let(:location_records) { [location_record] }
    let(:location_repository) { class_double('Location', all: double(includes: location_records)) }

    subject(:locations) { described_class.new(location_repository: location_repository).all }

    it { is_expected.to include(a_kind_of(Space::Locations::Location)) }

    context 'then the first location' do
      subject(:location) { locations.first }

      it_behaves_like 'a location'
    end
  end

  context 'when finding first location' do
    let(:location_repository) do
      class_double('Location').tap do |double|
        allow(double).to receive(:first).and_return(location_record)
      end
    end

    subject(:location) { described_class.new(location_repository: location_repository).first }

    it_behaves_like 'a location'

    context 'and location does not exist' do
      let(:location_record) { nil }
      it { is_expected.to be_nil }
    end
  end

  context 'when finding a location record' do
    let(:location_repository) do
      class_double('Location').tap do |double|
        allow(double).to receive(:find_by).with(id: location_record_id).and_return(location_record)
      end
    end

    subject(:location) { described_class.new(location_repository: location_repository).find(location_record_id) }

    it_behaves_like 'a location'

    context 'and location does not exist' do
      let(:location_record) { nil }
      it { is_expected.to be_nil }
    end
  end

  context 'when finding a location record by slug' do
    let(:location_repository) do
      class_double('Location').tap do |double|
        allow(double).to receive(:find_by).with(slug: location_record_slug).and_return(location_record)
      end
    end

    subject { described_class.new(location_repository: location_repository).find_by_slug(location_record_slug) }

    it { is_expected.to be_a(Space::Locations::Location) }

    context 'and location does not exist' do
      let(:location_record) { nil }
      it { is_expected.to be_nil }
    end
  end
end
