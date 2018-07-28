require_relative '../../../../lib/space/locations/dock_gateway'

RSpec.describe Space::Locations::DockGateway do
  context 'when finding a dock record' do
    let(:dock_record_slug) { 'dock-at-london' }
    let(:dock_record) do
      instance_double(
        'Dock',
        id: 1,
        location: instance_double('Location', id: 1, establishments: [], name: 'London'),
        ships: [],
        slug: dock_record_slug
      )
    end

    let(:dock_repository) do
      class_double('Dock').tap do |double|
        allow(double).to receive(:find_by).with(slug: dock_record_slug).and_return(dock_record)
      end
    end

    subject { described_class.new(dock_repository: dock_repository).find_by_slug(dock_record_slug) }

    it { is_expected.to be_a(Space::Locations::Dock) }

    it 'should return dock with location' do
      expect(subject.location).to be_a(Space::Locations::Location)
    end

    context 'and dock does not exist' do
      let(:dock_record) { nil }
      it { is_expected.to be_nil }
    end
  end
end
