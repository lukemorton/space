module Space
  module Flight
    class TravelComputerFactory
      def create_fuel_calculator(ship)
        FuelCalculator.new(ship: ship)
      end

      def create_travel_validator(ship, destination_location)
        TravelValidator.new(
          destination_location: destination_location,
          fuel_calculator: create_fuel_calculator(ship),
          ship: ship
        )
      end

      class FuelCalculator
        def initialize(ship:)
          @ship = ship
        end

        def new_fuel_level
          ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL
        end

        private

        attr_reader :ship
      end

      class TravelValidator
        include ActiveModel::Model

        attr_accessor :destination_location, :fuel_calculator, :ship

        validate :ship_has_enough_fuel
        validate :not_travelling_to_same_location

        private

        def ship_has_enough_fuel
          if fuel_calculator.new_fuel_level < 0
            errors.add(:fuel, 'too low')
          end
        end

        def not_travelling_to_same_location
          if ship.location.id.to_s == destination_location.id.to_s
            errors.add(:destination_location, 'is same as current location')
          end
        end
      end
    end
  end
end
