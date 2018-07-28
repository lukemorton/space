require_relative '../../../../lib/space/locations/view_dock'

RSpec.describe Space::Locations::ViewDock do
  let(:dock_gateway) { instance_double('Space::Locations::DockGateway', find: nil) }
  let(:dock) do
    instance_double(
      'Space::Locations::Dock',
      id: 1,
      location: instance_double('Space::Locations::Location'),
      name: 'Dock',
      ships: []
    )
  end

  let(:use_case) do
    allow(dock_gateway).to receive(:find).with(dock.id).and_return(dock)
    described_class.new(
      dock_gateway: dock_gateway
    )
  end

  context 'when viewing current dock' do
    subject { use_case.view(dock.id) }

    it 'should have name' do
      expect(subject.name).to eq('Dock')
    end
  end

  context 'when viewing invalid dock' do
    subject { use_case.view(nil) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::UnknownDockError)
    end
  end
end
