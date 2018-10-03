require_relative '../../../../lib/space/folk/create_person'

RSpec.describe Space::Folk::CreatePerson do
  context 'when creating person' do
    let(:location) { instance_double('Space::Locations::Location', id: 2) }
    let(:location_gateway) { instance_double('Space::Flight::LocationGateway', first: location) }
    let(:person) { instance_double('Space::Folk::Person', id: 1) }
    let(:person_gateway) { instance_double('Space::Folk::PersonGateway', create: person) }
    let(:money_gateway) { instance_double('Space::Folk::MoneyGateway', initialize_bank: true) }

    let(:use_case) do
      described_class.new(
        location_gateway: location_gateway,
        money_gateway: money_gateway,
        person_gateway: person_gateway
      )
    end

    subject { use_case.create(1, name: 'Luke') }

    it 'allows valid travel' do
      expect(subject).to be_successful
    end

    it 'creates person' do
      subject
      expect(person_gateway).to have_received(:create).with(a_hash_including(
        name: 'Luke'
      ))
    end

    it 'passes location_id' do
      subject
      expect(person_gateway).to have_received(:create).with(a_hash_including(
        location_id: location.id
      ))
    end

    it 'passes user_id' do
      subject
      expect(person_gateway).to have_received(:create).with(a_hash_including(
        user_id: 1
      ))
    end

    it 'creates bank account' do
      subject
      expect(money_gateway).to have_received(:initialize_bank).with(person)
    end

    context 'and name not provided' do
      subject { use_case.create(1, {}) }

      it 'disallows travel' do
        expect(subject).to_not be_successful
      end

      it 'provides an error' do
        expect(subject.validator.errors.full_messages).to include('Name can\'t be blank')
      end
    end

    context 'and gateway could not create' do
      let(:person_gateway) { instance_double('Space::Folk::PersonGateway', create: nil) }

      it 'raises exception' do
        expect{subject}.to raise_error(Space::Folk::CouldNotCreatePersonError)
      end
    end
  end
end
