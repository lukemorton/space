require_relative '../../../../lib/space/flight/view_controls'

RSpec.describe Space::Flight::ViewControls do
  let(:fuel_calculator) { instance_double('Space::Flight::TravelComputerFactory::FuelCalculator', name: 'A', description: 'B') }
  let(:travel_validator) { instance_double('Space::Flight::TravelComputerFactory::TravelValidator', name: 'A', description: 'B') }
  let(:travel_computer_factory) { instance_double('Space::Flight::TravelComputerFactory', create_fuel_calculator: fuel_calculator, create_travel_validator: travel_validator) }

  let(:use_case) do
    ship_gateway = instance_double('Space::Flight::ShipGateway', find_by_slug: nil).tap do |double|
      allow(double).to receive(:find_by_slug).with(ship.slug).and_return(ship)
    end

    described_class.new(
      location_gateway: instance_double('Space::Locations::LocationGateway', all: locations),
      person_gateway: instance_double('Space::Locations::PersonGateway', find: person),
      ship_gateway: ship_gateway,
      travel_computer_factory: travel_computer_factory
    )
  end

  context 'when viewing flight controls' do
    let(:person) { instance_double('Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Ship', id: 1, crew: [person], name: 'Endeavour', slug: 'endeavour') }
    let(:locations) { [instance_double('Location', id: 1, name: 'London')] }

    subject { use_case.view(ship.slug, person.id) }

    it 'should have ship' do
      expect(subject.ship.id).to eq(ship.id)
    end

    it 'should have locations' do
      expect(subject.locations).to_not be_empty
    end

    it 'should have fuel calculator meta data' do
      expect(subject.computers.fuel_calculator.name).to eq(fuel_calculator.name)
      expect(subject.computers.fuel_calculator.description).to eq(fuel_calculator.description)
    end
  end

  context 'when not in crew' do
    let(:person) { instance_double('Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Ship', id: 1, crew: [], name: 'Endeavour', slug: 'endeavour') }
    let(:locations) { [instance_double('Location', id: 1, name: 'London')] }

    subject { use_case.view(ship.slug, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Flight::PersonNotInCrewError)
    end
  end

  context 'when ship unknown' do
    let(:person) { instance_double('Person', id: 1, name: 'Luke') }
    let(:ship) { instance_double('Ship', id: 1, crew: [], name: 'Endeavour', slug: 'endeavour') }
    let(:locations) { [instance_double('Location', id: 1, name: 'London')] }

    subject { use_case.view(nil, person.id) }

    it 'should raise an error' do
      expect { subject }.to raise_error(Space::Flight::UnknownShipError)
    end
  end
end
