require_relative '../../../../lib/space/locations/dock_gateway'

RSpec.describe Space::Locations::DockGateway do
  context 'when finding a dock record' do
    let(:location_record) do
      instance_double('Location', id: 1, name: 'London', slug: 'london')
    end

    let(:person_record) do
      instance_double('Person', id: 1, name: 'Luke')
    end

    let(:ship_record) do
      instance_double('Ship', id: 1, crew: [person_record], name: 'Endeavour', slug: 'endeavour')
    end

    let(:dock_record_slug) { 'london-dock' }
    let(:dock_record) do
      instance_double(
        'Dock',
        id: 1,
        location: location_record,
        name: 'London Dock',
        ships: [ship_record],
        slug: dock_record_slug
      )
    end

    let(:dock_repository) do
      class_double('Dock').tap do |double|
        allow(double).to receive(:find_by).with(slug: dock_record_slug).and_return(dock_record)
      end
    end

    subject(:dock) { described_class.new(dock_repository: dock_repository).find_by_slug(dock_record_slug) }

    it { is_expected.to be_a(Space::Locations::Dock) }

    it 'has location' do
      expect(dock.location.name).to eq(location_record.name)
    end

    it 'has name' do
      expect(dock.name).to eq(dock_record.name)
    end

    it 'has ships' do
      expect(dock.ships.first.name).to eq(ship_record.name)
    end

    it 'has ships with crew names' do
      expect(dock.ships.first.crew.first.name).to eq(person_record.name)
    end

    it 'has slug' do
      expect(dock.slug).to eq(dock_record.slug)
    end

    it 'generates param from slug' do
      expect(dock.to_param).to eq(dock_record.slug)
    end

    context 'and dock does not exist' do
      let(:dock_record) { nil }
      it { is_expected.to be_nil }
    end
  end
end
