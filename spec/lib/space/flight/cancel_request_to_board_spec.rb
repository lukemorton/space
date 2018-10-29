require_relative '../../../../lib/space/flight/cancel_request_to_board'

RSpec.describe Space::Flight::CancelRequestToBoard do
  context 'when cancelling request to board a ship' do
    let(:person) { instance_double('Space::Folk::Person', id: 1) }
    let(:ship_boarding_request_id) { 1 }
    let(:ship_boarding_request_gateway) { instance_double('Space::Flight::ShipBoardingRequestGateway', cancel: nil) }

    let(:use_case) do
      described_class.new(
        ship_boarding_request_gateway: ship_boarding_request_gateway
      )
    end

    subject { use_case.cancel(ship_boarding_request_id, person.id) }

    it 'allows a person to cancel request to board' do
      expect(subject).to be_successful
    end

    it 'should cancel request to board' do
      subject
      expect(ship_boarding_request_gateway).to have_received(:cancel).with(ship_boarding_request_id, person.id)
    end
  end
end
