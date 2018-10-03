require_relative '../../../../lib/space/folk/person_gateway'

RSpec.describe Space::Folk::PersonGateway do
  shared_examples 'a person' do
    it { is_expected.to be_a(Space::Folk::Person) }

    it 'has an id' do
      expect(person.id).to eq(person_record.id)
    end

    it 'has location' do
      expect(person.location).to_not be_nil
    end

    it 'has a location with slug' do
      expect(person.location.slug).to eq(location_record.slug)
    end

    it 'can generate location param from location slug' do
      expect(person.location.to_param).to eq(location_record.slug)
    end

    it 'has name' do
      expect(person.name).to eq(person_record.name)
    end

    it 'has ship' do
      expect(person.ship.id).to eq(ship_record.id)
    end

    it 'has a ship with slug' do
      expect(person.ship.slug).to eq(ship_record.slug)
    end

    it 'can generate ship param from ship slug' do
      expect(person.ship.to_param).to eq(ship_record.slug)
    end

    it 'can be aboard ship' do
      expect(person).to be_aboard_ship
    end

    it 'has location with id' do
      expect(person.location.id).to eq(location_record.id)
    end
  end

  context 'when finding a person record' do
    let(:ship_record) { instance_double('Ship', id: 1, slug: 'endeavour') }
    let(:location_record) { instance_double('Location', id: 1, slug: 'london') }
    let(:person_record) { instance_double('Person', id: 1, name: 'Luke', location: location_record, ship: ship_record) }
    let(:person_repository) { class_double('Person', find_by: person_record) }

    subject(:person) { described_class.new(person_repository: person_repository).find(1) }

    it_behaves_like 'a person'

    context 'and person does not exist' do
      let(:person_record) { nil }
      it { is_expected.to be_nil }
    end
  end

  context 'when creating a person record' do
    let(:ship_record) { instance_double('Ship', id: 1, slug: 'endeavour') }
    let(:location_record) { instance_double('Location', id: 1, slug: 'london') }
    let(:person_attrs) { { location_id: 1, name: 'Luke', user_id: 1 } }
    let(:person_record) { instance_double('Person', person_attrs.merge(id: 1, location: location_record, ship: ship_record)) }
    let(:person_repository) { class_double('Person', create: person_record) }

    subject(:person) do
      described_class.new(person_repository: person_repository).create(person_attrs)
    end

    it_behaves_like 'a person'

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
