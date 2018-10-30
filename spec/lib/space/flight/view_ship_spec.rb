require_relative '../../../../lib/space/flight/view_ship'

RSpec.describe Space::Flight::ViewShip do
  let(:fuel_calculator) { instance_double('Space::Computers::BasicFuelCalculator', name: 'A', description: 'B', fuel_to_travel: 10, new_fuel_level: 90) }
  let(:travel_computer_factory) { instance_double('Space::Flight::TravelComputerFactory', create_fuel_calculator: fuel_calculator) }

  let(:use_case) do
    ship_gateway = instance_double('Space::Flight::ShipGateway', find_by_slug: nil).tap do |double|
      allow(double).to receive(:find_by_slug).with(ship.slug).and_return(ship)
    end

    described_class.new(
      list_destinations_use_case: instance_double('Space::Flight::ListDestinations', list: double(destinations: destinations)),
      person_gateway: instance_double('Space::Locations::PersonGateway', find: person),
      ship_gateway: ship_gateway,
      travel_computer_factory: travel_computer_factory
    )
  end

  context 'when viewing flight controls' do
    let(:person) { instance_double('Space::Folk::Person', id: 1, name: 'Luke') }
    let(:location) { instance_double('Space::Locations::Location', id: 1, name: 'London', coordinates: [1, 2, 3]) }
    let(:another_location) { instance_double('Space::Locations::Location', id: 2, name: 'Paris', coordinates: [4, 5, 6]) }
    let(:yet_another_location) { instance_double('Space::Locations::Location', id: 2, name: 'Paris', coordinates: [1, 2, 4]) }
    let(:destinations) { [location, another_location, yet_another_location] }
    let(:ship) { instance_double('Space::Flight::Ship', id: 1, crew: [person], fuel: 1000, has_crew_member_id?: true, location: location, name: 'Endeavour', slug: 'endeavour') }

    subject { use_case.view(ship.slug, person.id) }

    it 'should have id' do
      expect(subject.id).to eq(ship.id)
    end

    it 'should have crew' do
      expect(subject.crew).to eq(ship.crew)
    end

    it 'should have crew names' do
      expect(subject.crew.first.name).to eq(ship.crew.first.name)
    end

    it 'should have fuel' do
      expect(subject.fuel).to eq(ship.fuel)
    end

    it 'indicate low on fuel' do
      expect(subject).to_not be_low_on_fuel
    end

    it 'indicate out of fuel' do
      expect(subject).to_not be_out_of_fuel
    end

    it 'should have location' do
      expect(subject.location).to eq(ship.location)
    end

    it 'should have name' do
      expect(subject.name).to eq(ship.name)
    end

    it 'should have slug' do
      expect(subject.slug).to eq(ship.slug)
    end

    it 'should have destinations' do
      expect(subject.destinations).to eq(destinations)
    end

    it 'should have fuel calculator meta data' do
      expect(subject.computers.fuel_calculator.name).to eq(fuel_calculator.name)
      expect(subject.computers.fuel_calculator.description).to eq(fuel_calculator.description)
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

  context 'when ship unknown' do
    let(:person) { instance_double('Space::Folk::Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Space::Flight::Ship', id: 1, slug: 'endeavour') }
    let(:destinations) { [instance_double('Space::Locations::Location', id: 1, name: 'London')] }

    subject { use_case.view(nil, person.id) }

    it 'should raise an error' do
      expect{subject}.to raise_error(Space::Flight::UnknownShipError)
    end
  end
end
