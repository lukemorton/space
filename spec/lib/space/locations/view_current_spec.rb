require_relative '../../../../lib/space/locations/view_current'

RSpec.describe Space::Locations::ViewCurrent do
  let(:location_gateway) { instance_double('Space::Locations::LocationGateway', find: location) }
  let(:person_gateway) { instance_double('Space::Locations::LocationGateway', find: person) }

  let(:use_case) do
    described_class.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end

  context 'when viewing current location' do
    let(:location) { instance_double('Location', id: 1, name: 'London') }
    let(:person) { instance_double('Person', id: 1, location_id: location.id) }

    subject { use_case.view(location.id, person.id) }

    it { is_expected.to be_current }

    it 'should have name' do
      expect(subject.location.name).to eq(location.name)
    end
  end

  context 'when viewing location other than current' do
    let(:location) { instance_double('Location', id: 1, name: 'London') }
    let(:person) { instance_double('Person', id: 1, location_id: 2) }

    subject { use_case.view(location.id, person.id) }

    it { is_expected.to_not be_current }
  end
end
