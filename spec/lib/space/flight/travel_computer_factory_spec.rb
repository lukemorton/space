require_relative '../../../../lib/space/flight/travel_computer_factory'
require_relative '../../../../lib/space/flight/ship'

RSpec.describe Space::Flight::TravelComputerFactory do
  let(:ship) do
    instance_double('Space::Flight::Ship', computer_references: double(
      fuel_calculator: :space_computers_basic_fuel_calculator
    ))
  end

  let(:destination_location) { instance_double('Location') }

  it 'creates a fuel calculator' do
    expect(subject.create_fuel_calculator(ship)).to respond_to(:new_fuel_level)
  end
end
