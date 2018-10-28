require_relative '../../../../lib/space/flight/request_to_board'

RSpec.describe Space::Flight::RequestToBoard do
  context 'when requesting to board a ship' do
    let(:person) { instance_double('Space::Folk::Person', id: 1) }
    let(:ship_id) { 1 }
    let(:ship) { instance_double('Space::Flight::Ship', id: ship_id, crew: [], has_crew_member_id?: false) }
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: ship) }
    let(:ship_boarding_request_gateway) { instance_double('Space::Flight::ShipBoardingRequestGateway', create: nil) }

    let(:use_case) do
      described_class.new(
        ship_boarding_request_gateway: ship_boarding_request_gateway,
        ship_gateway: ship_gateway
      )
    end

    subject { use_case.request(ship_id, person.id) }

    it 'allows a person to request to board' do
      expect(subject).to be_successful
    end

    it 'should create request to board' do
      subject
      expect(ship_boarding_request_gateway).to have_received(:create).with(ship_id, person.id)
    end

    context 'and ship does not exist' do
      let(:ship) { nil }

      it 'disallows person to board' do
        expect{subject}.to raise_error(Space::Flight::UnknownShipError)
      end
    end

    context 'and person is part of crew' do
      let(:ship) { instance_double('Space::Flight::Ship', id: ship_id, crew: [person], has_crew_member_id?: true) }

      it { is_expected.to_not be_successful }

      it 'disallows person to board' do
        expect(subject.errors).to_not be_empty
      end
    end
  end
end
