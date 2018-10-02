require 'active_model'
require_relative '../computers/basic_fuel_calculator'

module Space
  module Flight
    class TravelComputerFactory
      def computers
        {
          space_computers_basic_fuel_calculator: Space::Computers::BasicFuelCalculator,
        }
      end

      def create_fuel_calculator(ship)
        fuel_calculator_class = computers.fetch(ship.computer_references.fuel_calculator)
        fuel_calculator_class.new(ship: ship)
      end
    end
  end
end
