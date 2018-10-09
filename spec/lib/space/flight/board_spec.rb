require_relative '../../../../lib/space/flight/board'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Flight::Board do
  context 'when boarding ship' do
    let(:person) { instance_double('Space::Folk::Person', id: 1) }
    let(:ship_id) { 1 }
    let(:ship) { Space::Flight::Ship.new(id: ship_id, crew: []) }
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: ship, add_crew_member: true) }

    let(:use_case) do
      described_class.new(
        ship_gateway: ship_gateway
      )
    end

    subject { use_case.board(person.id, ship_id) }

    it 'allows a person to board' do
      expect(subject).to be_successful
    end

    it 'adds boarding person to crew' do
      subject
      expect(ship_gateway).to have_received(:add_crew_member).with(ship_id, person.id)
    end

    context 'and ship does not exist' do
      let(:ship) { nil }

      it 'disallows person to board' do
        expect{subject}.to raise_error(Space::Flight::UnknownShipError)
      end
    end

    context 'and person is part of crew' do
      let(:ship) { Space::Flight::Ship.new(id: ship_id, crew: [person]) }

      it { is_expected.to_not be_successful }

      it 'disallows person to board' do
        expect(subject.errors).to_not be_empty
      end
    end
  end
end
