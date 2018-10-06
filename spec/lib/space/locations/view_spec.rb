require_relative '../../../../lib/space/locations/view'

RSpec.describe Space::Locations::View do
  context 'when viewing location' do
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find_by_slug: location) }
    let(:location) { instance_double('Space::Locations::Location', id: 1, coordinates: [1, 2, 3], name: 'London', establishments: [], slug: 'London') }

    subject { described_class.new(location_gateway: location_gateway).view(location.slug) }

    it 'should have coordinates' do
      expect(subject.coordinates).to eq(location.coordinates)
    end

    it 'should have name' do
      expect(subject.name).to eq(location.name)
    end

    it 'should have establishments' do
      expect(subject.establishments).to be_empty
    end
  end

  context 'when viewing invalid location' do
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find_by_slug: nil) }

    subject { described_class.new(location_gateway: location_gateway).view(nil) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::UnknownLocationError)
    end
  end
end
