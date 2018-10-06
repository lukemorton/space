require 'active_model'
require_relative '../computers/basic_fuel_calculator'
require_relative '../computers/euclidean_distance_calculator'

module Space
  module Flight
    class TravelComputerFactory
      def computers
        {
          space_computers_basic_fuel_calculator: Space::Computers::BasicFuelCalculator,
          space_computers_euclidean_distance_calculator: Space::Computers::EuclideanDistanceCalculator
        }
      end

      def create_distance_calculator(ship)
        distance_calculator_class = computers.fetch(ship.computer_references.distance_calculator)
        distance_calculator_class.new
      end

      def create_fuel_calculator(ship)
        fuel_calculator_class = computers.fetch(ship.computer_references.fuel_calculator)
        fuel_calculator_class.new(
          distance_calculator: create_distance_calculator(ship),
          ship: ship
        )
      end
    end
  end
end
