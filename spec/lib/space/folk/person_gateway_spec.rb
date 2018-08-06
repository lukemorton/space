require_relative '../../../../lib/space/folk/person_gateway'

RSpec.describe Space::Folk::PersonGateway do
  context 'when finding a person record' do
    let(:location_record) { instance_double('Location', id: 1) }
    let(:person_record) { instance_double('Person', id: 1, location: location_record) }
    let(:person_repository) { class_double('Person', find_by: person_record) }

    subject(:person) { described_class.new(person_repository: person_repository).find(1) }

    it { is_expected.to be_a(Space::Folk::Person) }

    it 'has an id' do
      expect(person.id).to eq(person_record.id)
    end

    it 'has location' do
      expect(person.location).to_not be_nil
    end

    it 'has location with id' do
      expect(person.location.id).to eq(location_record.id)
    end

    context 'and person does not exist' do
      let(:person_record) { nil }
      it { is_expected.to be_nil }
    end
  end

  context 'when creating a person record' do
    let(:person_repository) { class_double('Person', create: true) }

    subject do
      described_class.new(person_repository: person_repository).create(
        location_id: 1,
        name: 'Luke',
        user_id: 1
      )
    end

    it { is_expected.to be(true) }

    it 'sets name' do
      subject
      expect(person_repository).to have_received(:create).with(a_hash_including(
        name: 'Luke'
      ))
    end

    it 'sets user_id' do
      subject
      expect(person_repository).to have_received(:create).with(a_hash_including(
        user_id: 1
      ))
    end

    it 'sets location_id' do
      subject
      expect(person_repository).to have_received(:create).with(a_hash_including(
        location_id: 1
      ))
    end
  end

  context 'when updating a person record' do
    let(:person_record) { instance_double('Person', id: 1, update: true) }
    let(:person_repository) { class_double('Person', find: person_record) }

    subject { described_class.new(person_repository: person_repository).update(person_record.id, location: nil) }

    it { is_expected.to be(true) }
  end
end
