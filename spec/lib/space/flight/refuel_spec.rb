require_relative '../../../../lib/space/flight/refuel'

RSpec.describe Space::Flight::Refuel do
  context 'when refueling' do
    let(:current_location) { instance_double('Location', id: 1) }

    let(:person) { instance_double('Person', id: 1, location: current_location, :location= => nil) }
    let(:person_gateway) { instance_double('Space::Folk::PersonGateway', update: true) }

    let(:ship) { instance_double('Space::Flight::Ship', id: 1, crew: [person], fuel: Space::Flight::Ship::LOW_FUEL, has_crew_member_id?: true, location: current_location) }
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: ship, update: true) }

    let(:use_case) do
      described_class.new(
        money_gateway: double,
        ship_gateway: ship_gateway,
      )
    end

    subject { use_case.refuel(ship.id, current_person: person.id, refuel: 'full_tank') }

    context 'and fully refueling' do
      subject { use_case.refuel(ship.id, current_person: person.id, refuel: 'full_tank') }

      it { is_expected.to be_successful }

      it 'consumes ship fuel' do
        subject
        expect(ship_gateway).to have_received(:update).with(
          ship.id,
          a_hash_including(fuel: Space::Flight::Ship::FUEL_MAX)
        )
      end
    end

    context 'and half refueling' do
      subject { use_case.refuel(ship.id, current_person: person.id, refuel: 'half_tank') }

      it { is_expected.to be_successful }

      it 'consumes ship fuel' do
        subject
        expect(ship_gateway).to have_received(:update).with(
          ship.id,
          a_hash_including(fuel: Space::Flight::Ship::FUEL_MAX / 2)
        )
      end
    end

    context 'and no ship found' do
      let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find: nil) }

      it 'disallows refuel' do
        expect{subject}.to raise_error(Space::Flight::UnknownShipError)
      end
    end

    context 'and person is not part of crew' do
      let(:ship) { instance_double('Space::Flight::Ship', id: 1, crew: [], fuel: Space::Flight::Ship::LOW_FUEL, has_crew_member_id?: false, location: current_location) }

      it 'disallows refuel' do
        expect{subject}.to raise_error(Space::Flight::PersonNotInCrewError)
      end
    end
  end
end
