require_relative '../../../../lib/space/flight/person_gateway'

RSpec.describe Space::Flight::PersonGateway do
  context 'when finding a person record' do
    let(:location_record) { instance_double('Location', id: 1, establishments: [], name: 'London') }
    let(:person_record) { instance_double('Person', id: 1, location: location_record) }
    let(:person_repository) { class_double('Person', find_by: person_record) }

    subject { described_class.new(person_repository: person_repository).find(1) }

    it { is_expected.to be_a(Space::Flight::Person) }

    context 'and person does not exist' do
      let(:person_record) { nil }
      it { is_expected.to be_nil }
    end
  end

  context 'when updating a person record' do
    let(:person_record) { instance_double('Person', id: 1, update: true) }
    let(:person_repository) { class_double('Person', find: person_record) }

    subject { described_class.new(person_repository: person_repository).update(person_record.id, location: nil) }

    it { is_expected.to be(true) }
  end
end
