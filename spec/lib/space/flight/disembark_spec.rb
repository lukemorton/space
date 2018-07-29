require_relative '../../../../lib/space/flight/disembark'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Flight::Disembark do
  context 'when disembarking ship' do
    let(:person) { instance_double('Person', id: 1) }
    let(:ship_id) { 1 }
    let(:ship) { Space::Flight::Ship.new(id: ship_id, crew: [person]) }
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: ship, remove_crew_member: true) }

    let(:use_case) do
      described_class.new(
        ship_gateway: ship_gateway
      )
    end

    subject { use_case.disembark(person.id, ship_id) }

    it 'allows a crew member to disembark' do
      expect(subject).to be_successful
    end

    it 'removes disembarking person from crew' do
      subject
      expect(ship_gateway).to have_received(:remove_crew_member).with(ship_id, person.id)
    end

    context 'and ship does not exist' do
      let(:ship) { nil }

      it 'disallows person to disembark' do
        expect(subject).not_to be_successful
      end
    end

    context 'and person is not part of crew' do
      let(:ship) { Space::Flight::Ship.new(id: 1, crew: []) }

      it 'disallows person to disembark' do
        expect(subject).not_to be_successful
      end
    end
  end
end
