require_relative '../../../../lib/space/locations/list'

RSpec.describe Space::Locations::List do
  context 'when listing locations' do
    let(:locations) { [double] }
    let(:location_gateway) { instance_double('Space::Locations::LocationGateway', all: locations) }

    subject { described_class.new(location_gateway: location_gateway).list }

    it { is_expected.to_not be_empty }
  end
end
