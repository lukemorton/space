require_relative '../../../../lib/space/locations/dock_gateway'

RSpec.describe Space::Locations::DockGateway do
  context 'when finding a dock record' do
    let(:dock_record) do
      instance_double(
        'Dock',
        id: 1
      )
    end

    let(:dock_repository) do
      class_double('Dock').tap do |double|
        allow(double).to receive(:find).with(dock_record.id).and_return(dock_record)
      end
    end

    subject { described_class.new(dock_repository: dock_repository).find(dock_record.id) }

    it { is_expected.to be_a(Space::Locations::Dock) }
  end
end
