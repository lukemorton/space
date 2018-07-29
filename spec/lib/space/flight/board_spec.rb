require_relative '../../../../lib/space/flight/board'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Flight::Board do
  context 'when boarding ship' do
    let(:person) { instance_double('Person', id: 1) }
    let(:ship) { Space::Flight::Ship.new(id: 1, crew: []) }
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: ship, add_crew_member: true) }

    let(:use_case) do
      described_class.new(
        ship_gateway: ship_gateway
      )
    end

    subject { use_case.board(person.id, ship.id) }

    it 'allows a person to board' do
      expect(subject).to be_successful
    end

    it 'adds boarding person to crew' do
      subject
      expect(ship_gateway).to have_received(:add_crew_member).with(ship.id, person.id)
    end

    context 'and person is part of crew' do
      let(:ship) { Space::Flight::Ship.new(id: 1, crew: [person]) }

      it 'disallows person to disembark' do
        expect(subject).not_to be_successful
      end
    end
  end
end
