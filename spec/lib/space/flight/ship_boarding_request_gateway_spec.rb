require_relative '../../../../lib/space/flight/ship_boarding_request_gateway'

RSpec.describe Space::Flight::ShipBoardingRequestGateway do
  let(:person_record) { instance_double('Person', id: 1) }
  let(:ship_record_id) { 1 }
  let(:ship_record) { instance_double('Ship', id: ship_record_id) }

  context 'when creating a ship boarding request record' do
    let(:ship_boarding_request_repository) { class_double('ShipBoardingRequest', create: true) }

    let(:gateway) { described_class.new(ship_boarding_request_repository: ship_boarding_request_repository) }

    subject { gateway.create(ship_record_id, person_record.id) }

    it { is_expected.to be(true) }

    it 'should call create with attrs' do
      subject
      expect(ship_boarding_request_repository).to have_received(:create).with(
        ship_id: ship_record_id,
        requester_id: person_record.id
      )
    end
  end

  context 'when cancelling a ship boarding request record' do
    let(:ship_boarding_request_repository) { class_double('ShipBoardingRequest', delete: true) }
    let(:ship_boarding_request_id) { 1 }

    let(:gateway) { described_class.new(ship_boarding_request_repository: ship_boarding_request_repository) }

    subject { gateway.cancel(ship_boarding_request_id, person_record.id) }

    it { is_expected.to be(true) }

    it 'should call delete with attrs' do
      subject
      expect(ship_boarding_request_repository).to have_received(:delete).with(
        id: ship_boarding_request_id,
        requester_id: person_record.id
      )
    end
  end
end
