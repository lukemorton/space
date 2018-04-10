require_relative '../../../../lib/space/flight/person_gateway'

RSpec.describe Space::Flight::PersonGateway do
  context 'when finding a person record' do
    let(:person_record) { instance_double('Person') }
    let(:person_repository) { class_double('Person', find: person_record) }

    subject { described_class.new(person_repository: person_repository).find(1) }

    it { is_expected.to be(person_record) }
  end

  context 'when updating a person record' do
    let(:person_repository) { class_double('Person') }
    let(:person) { instance_double('Person', save!: true) }

    subject { described_class.new(person_repository: person_repository).update(person) }

    it { is_expected.to be(true) }
  end
end
