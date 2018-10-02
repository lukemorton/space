module Space
  module Computers
    class BasicFuelCalculator
      def initialize(ship:)
        @ship = ship
      end

      def name
        'Basic Fuel Calculator by Space Inc.'
      end

      def description
        'An inefficient fuel calculator.'
      end

      def fuel_to_travel
        Space::Flight::Ship::FUEL_TO_TRAVEL
      end

      def new_fuel_level
        ship.fuel - fuel_to_travel
      end

      private

      attr_reader :ship
    end
  end
end
