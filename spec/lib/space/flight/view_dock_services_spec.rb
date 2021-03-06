require_relative '../../../../lib/space/flight/view_dock_services'

RSpec.describe Space::Flight::ViewDockServices do
  let(:money_gateway) { instance_double('Space::Folk::MoneyGateway', bank_balance: Money.new(500_00)) }

  let(:person) { instance_double('Space::Folk::Person', id: 1, name: 'Luke') }
  let(:person_gateway) { instance_double('Space::Locations::PersonGateway', find: person) }

  let(:ship) { instance_double('Space::Flight::Ship', id: 1, has_crew_member_id?: true, fuel: 1000, has_crew_member_id?: true, slug: 'endeavour') }
  let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find_by_slug: ship) }

  let(:use_case) do
    described_class.new(
      money_gateway: money_gateway,
      person_gateway: person_gateway,
      ship_gateway: ship_gateway
    )
  end

  context 'when viewing dock services' do
    subject { use_case.view(ship.slug, person.id) }

    it 'returns refuel service' do
      expect(subject).to respond_to(:refuel_service)
    end
  end

  context 'when viewing refuel service' do
    subject { use_case.view(ship.slug, person.id).refuel_service }

    it 'returns two options' do
      expect(subject.options.count).to eq(2)
    end

    it 'returns full refuel as the first option' do
      expect(subject.options.first.type).to eq(:full_tank)
    end

    it 'returns half refuel as the last option' do
      expect(subject.options.last.type).to eq(:half_tank)
    end

    context 'and fully refueling' do
      subject { use_case.view(ship.slug, person.id).refuel_service.options.first }

      it 'should check person bank balance to ensure they can afford to refuel' do
        subject
        expect(money_gateway).to have_received(:bank_balance).with(person)
      end

      context 'and person can afford' do
        let(:money_gateway) { instance_double('Space::Folk::MoneyGateway', bank_balance: Money.new(500_00)) }

        it 'costs 300' do
          expect(subject.cost).to eq(Money.new(300_00))
        end

        it 'should be affordable for person' do
          expect(subject).to be_affordable_for_person
        end
      end

      context 'and person cannot afford' do
        let(:money_gateway) { instance_double('Space::Folk::MoneyGateway', bank_balance: Money.new(200_00)) }

        it 'should not be affordable for person' do
          expect(subject).to_not be_affordable_for_person
        end
      end
    end

    context 'then half refueling' do
      subject { use_case.view(ship.slug, person.id).refuel_service.options.last }

      it 'costs 150' do
        expect(subject.cost).to eq(Money.new(150_00))
      end
    end
  end

  context 'when ship unknown' do
    let(:ship_gateway) { instance_double('Space::Flight::ShipGateway', find_by_slug: nil) }

    subject { use_case.view(nil, person.id) }

    it 'should raise an error' do
      expect{subject}.to raise_error(Space::Flight::UnknownShipError)
    end
  end

  context 'when not in crew' do
    let(:person) { instance_double('Space::Folk::Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Space::Flight::Ship', id: 1, has_crew_member_id?: false, slug: 'endeavour') }
    let(:destinations) { [instance_double('Space::Locations::Location', id: 1, name: 'London')] }

    subject { use_case.view(ship.slug, person.id) }

    it 'should raise an error' do
      expect{subject}.to raise_error(Space::Flight::PersonNotInCrewError)
    end
  end
end
