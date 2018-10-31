require_relative '../../../../lib/space/flight/accept_request_to_board'

RSpec.describe Space::Flight::AcceptRequestToBoard do
  context 'when accepting request to board a ship' do
    let(:crew_member) { instance_double('Space::Folk::Person', id: 1) }
    let(:requester) { instance_double('Space::Folk::Person', id: 2) }
    let(:ship) { instance_double('Space::Flight::Ship::BoardingRequest::Ship', has_crew_member_id?: true) }
    let(:ship_boarding_request_id) { 1 }
    let(:ship_boarding_request) do
      instance_double(
        'Space::Flight::Ship::BoardingRequest',
        id: ship_boarding_request_id,
        ship: ship,
        requester: requester
      )
    end
    let(:ship_boarding_request_gateway) { instance_double('Space::Flight::ShipBoardingRequestGateway', find: ship_boarding_request, delete: 1) }
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', add_crew_member: true) }

    let(:use_case) do
      described_class.new(
        ship_boarding_request_gateway: ship_boarding_request_gateway,
        ship_gateway: ship_gateway
      )
    end

    subject { use_case.accept(ship_boarding_request_id, crew_member.id) }

    it 'allows a crew member to accept request to board' do
      expect(subject).to be_successful
    end

    it 'should find boarding request' do
      subject
      expect(ship_boarding_request_gateway).to have_received(:find).with(ship_boarding_request_id)
    end

    it 'should cancels request to board' do
      subject
      expect(ship_boarding_request_gateway).to have_received(:delete).with(ship_boarding_request_id)
    end

    it 'should add requester to crew' do
      subject
      expect(ship_gateway).to have_received(:add_crew_member).with(requester.id)
    end

    context 'when ship boarding request unknown' do
      let(:ship_boarding_request_gateway) { instance_double('Space::Flight::ShipBoardingRequestGateway', find: nil) }

      it 'should raise an error' do
        expect{subject}.to raise_error(Space::Flight::UnknownShipBoardingRequestError)
      end
    end

    context 'and person is not part of crew' do
      let(:ship) { instance_double('Space::Flight::Ship::BoardingRequest::Ship', has_crew_member_id?: false) }

      it 'disallows person to accept boarding request' do
        expect{subject}.to raise_error(Space::Flight::PersonNotInCrewError)
      end
    end
  end
end
