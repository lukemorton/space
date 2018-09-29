module Space
  module Computers
    class BasicFuelCalculator
      def initialize(ship:)
        @ship = ship
      end

      def new_fuel_level
        ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL
      end

      private

      attr_reader :ship
    end
  end
end
