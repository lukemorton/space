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

  context 'when finding a ship boarding request record' do
    let(:ship_boarding_request_record_id) { 1 }
    let(:ship_boarding_request_record) { instance_double('ShipBoardingRequest', id: ship_boarding_request_record_id, ship: instance_double('Ship').as_null_object, requester: instance_double('Person', id: 1, name: 'Luke')) }

    let(:ship_boarding_request_repository) do
      class_double('ShipBoardingRequest').tap do |double|
        allow(double).to receive(:find_by).with(id: ship_boarding_request_record_id).and_return(ship_boarding_request_record)
      end
    end

    let(:gateway) { described_class.new(ship_boarding_request_repository: ship_boarding_request_repository) }

    subject { gateway.find(ship_boarding_request_record_id) }

    it { is_expected.to be_a(Space::Flight::ShipBoardingRequest) }

    it 'has id' do
      expect(subject.id).to eq(ship_boarding_request_record_id)
    end

    it 'has ship' do
      expect(subject.ship).to be_a(Space::Flight::Ship)
    end

    it 'has requester with id' do
      expect(subject.requester.id).to eq(1)
    end

    it 'has requester with name' do
      expect(subject.requester.name).to eq('Luke')
    end

    context 'and ship boarding request does not exist' do
      let(:ship_boarding_request_record) { nil }
      it { is_expected.to be_nil }
    end
  end

  context 'when cancelling a ship boarding request record' do
    let(:ship_boarding_requests) { double(delete_all: 1) }
    let(:ship_boarding_request_repository) { class_double('ShipBoardingRequest', where: ship_boarding_requests) }
    let(:ship_boarding_request_id) { 1 }

    let(:gateway) { described_class.new(ship_boarding_request_repository: ship_boarding_request_repository) }

    subject { gateway.cancel(ship_boarding_request_id, person_record.id) }

    it { is_expected.to be(true) }

    it 'should find request and then delete' do
      subject
      expect(ship_boarding_request_repository).to have_received(:where).with(
        id: ship_boarding_request_id,
        requester_id: person_record.id
      )
      expect(ship_boarding_requests).to have_received(:delete_all)
    end
  end
end
