require_relative '../../../../lib/space/folk/create_person'

RSpec.describe Space::Folk::CreatePerson do
  context 'when creating person' do
    # let(:person) { instance_double('Person', id: 1, location: current_station, :location= => nil) }
    # let(:ship) { instance_double('Space::Flight::Ship', id: 1, crew: [person], fuel: Space::Flight::Ship::FUEL_MAX, location: current_station) }
    let(:person_gateway) { instance_double('Space::Folk::PersonGateway', create: true) }
    # let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: ship, update: true) }

    let(:use_case) do
      described_class.new(
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

    it 'passes user_id' do
      subject
      expect(person_gateway).to have_received(:create).with(a_hash_including(
        user_id: 1
      ))
    end

    context 'and name not provided' do
      subject { use_case.create(1, {}) }

      it 'disallows travel' do
        expect(subject).to_not be_successful
      end

      it 'provides an error' do
        expect(subject.validation.errors).to include('Name can\'t be blank')
      end
    end

    context 'and gateway could not creatw' do
      let(:person_gateway) { instance_double('Space::Folk::PersonGateway', create: false) }

      it 'raises exception' do
        expect{subject}.to raise_error(Space::Folk::CouldNotCreatePersonError)
      end
    end
  end
end
