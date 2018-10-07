module Space
  module Computers
    class BasicFuelCalculator
      def initialize(distance_calculator:, ship:)
        @distance_calculator = distance_calculator
        @ship = ship
      end

      def name
        'Basic Fuel Calculator by Space Inc.'
      end

      def description
        'An inefficient fuel calculator.'
      end

      def fuel_to_travel(destination)
        (distance(destination) * Space::Flight::Ship::FUEL_TO_TRAVEL).to_i
      end

      def new_fuel_level(destination)
        ship.fuel - fuel_to_travel(destination)
      end

      private

      attr_reader :distance_calculator, :ship

      def distance(destination)
        distance_calculator.distance_between(ship.location, destination)
      end
    end
  end
end
