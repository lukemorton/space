require_relative '../../../../lib/space/locations/view_current'

RSpec.describe Space::Locations::ViewCurrent do
  let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find: nil) }
  let(:person_gateway) { instance_double('Space::Locations::LocationGateway', find: person) }
  let(:location) { instance_double('Location', id: 1, establishments: [], name: 'London') }
  let(:person) { instance_double('Person', id: 1, location: location) }

  let(:use_case) do
    allow(location_gateway).to receive(:find).with(location.id).and_return(location)
    described_class.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end

  context 'when viewing current location' do
    subject { use_case.view(location.id, person.id) }

    it { is_expected.to be_current }

    it 'should have name' do
      expect(subject.location.name).to eq(location.name)
    end
  end

  context 'when viewing location other than current' do
    let(:other_location) { instance_double('Location', id: 2, establishments: [], name: 'London') }
    let(:person) { instance_double('Person', id: 1, location: other_location) }

    subject { use_case.view(location.id, person.id) }

    it { is_expected.to_not be_current }
  end

  context 'when viewing invalid location' do
    subject { use_case.view(nil, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Locations::UnknownLocationError)
    end
  end
end
