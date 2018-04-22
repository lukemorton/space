require_relative '../../../../lib/space/locations/view'

RSpec.describe Space::Locations::View do
  context 'when viewing location' do
    let(:location) { instance_double('Location', id: 1, name: 'London') }
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find: location) }

    subject { described_class.new(location_gateway: location_gateway).view(location.id) }

    it 'should have name' do
      expect(subject.name).to eq(location.name)
    end
  end
end
