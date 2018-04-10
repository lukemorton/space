require_relative '../../../../lib/space/flight/person_gateway'

RSpec.describe Space::Flight::PersonGateway do
  context 'when updating a person record' do
    let(:person_repository) { class_double('Person', find: double(update!: true)) }
    let(:person) { double(id: 1, to_h: { id: 1 }) }

    subject { described_class.new(person_repository: person_repository).update(person) }

    it { is_expected.to be(true) }
  end
end
