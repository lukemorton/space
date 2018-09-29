require 'active_model'
require_relative '../computers/basic_fuel_calculator'
require_relative '../computers/basic_travel_validator'

module Space
  module Flight
    class TravelComputerFactory
      def computers
        {
          space_computers_basic_fuel_calculator: Space::Computers::BasicFuelCalculator,
          space_computers_basic_travel_validator: Space::Computers::BasicTravelValidator
        }
      end

      def create_fuel_calculator(ship)
        fuel_calculator_class = computers.fetch(ship.computer_references.fuel_calculator)
        fuel_calculator_class.new(ship: ship)
      end

      def create_travel_validator(ship, destination_location)
        travel_validator_class = computers.fetch(ship.computer_references.travel_validator)
        travel_validator_class.new(
          destination_location: destination_location,
          fuel_calculator: create_fuel_calculator(ship),
          ship: ship
        )
      end
    end
  end
end
