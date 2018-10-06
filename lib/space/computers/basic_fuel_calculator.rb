module Space
  module Computers
    class BasicFuelCalculator
      def initialize(distance_calculator:, ship:)
        @ship = ship
      end

      def name
        'Basic Fuel Calculator by Space Inc.'
      end

      def description
        'An inefficient fuel calculator.'
      end

      def fuel_to_travel(destination)
        Space::Flight::Ship::FUEL_TO_TRAVEL
      end

      def new_fuel_level(destination)
        ship.fuel - fuel_to_travel(destination)
      end

      private

      attr_reader :ship
    end
  end
end
