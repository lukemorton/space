require_relative '../../../../lib/space/flight/view_crew_overview'

RSpec.describe Space::Flight::ViewCrewOverview do
  let(:use_case) do
    ship_gateway = instance_double('Space::Flight::ShipGateway', find_by_slug: nil).tap do |double|
      allow(double).to receive(:find_by_slug).with(ship.slug).and_return(ship)
    end

    described_class.new(
      person_gateway: instance_double('Space::Locations::PersonGateway', find: person),
      ship_gateway: ship_gateway
    )
  end

  context 'when viewing flight controls' do
    let(:boarding_request) do
      instance_double(
        'Space::Flight::Ship::BoardingRequest',
        id: 1,
        requester: instance_double('Space::Flight::Ship::BoardingRequest::Requester', name: 'Luke')
      )
    end
    let(:person) { instance_double('Space::Folk::Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Space::Flight::Ship', boarding_requests: [boarding_request], crew: [person], has_crew_member_id?: true, slug: 'endeavour') }

    subject { use_case.view(ship.slug, person.id) }

    it 'should have boarding requests' do
      expect(subject.boarding_requests).to_not be_empty
    end

    it 'should have boarding requests with requester name' do
      expect(subject.boarding_requests.first.requester.name).to eq('Luke')
    end

    it 'should have crew' do
      expect(subject.crew).to eq(ship.crew)
    end

    it 'should have crew names' do
      expect(subject.crew.first.name).to eq(ship.crew.first.name)
    end
  end

  context 'when not in crew' do
    let(:person) { instance_double('Space::Folk::Person', id: 1) }
    let(:ship) { instance_double('Space::Flight::Ship', has_crew_member_id?: false, slug: 'endeavour') }

    subject { use_case.view(ship.slug, person.id) }

    it 'should raise an error' do
      expect{subject}.to raise_error(Space::Flight::PersonNotInCrewError)
    end
  end

  context 'when ship unknown' do
    let(:person) { instance_double('Space::Folk::Person', id: 1) }
    let(:ship) { instance_double('Space::Flight::Ship', slug: 'endeavour') }

    subject { use_case.view(nil, person.id) }

    it 'should raise an error' do
      expect{subject}.to raise_error(Space::Flight::UnknownShipError)
    end
  end
end
