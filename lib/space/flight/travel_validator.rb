require 'active_model'

module Space
  module Flight
    class TravelValidator
      include ActiveModel::Model

      attr_accessor :destination_location, :fuel_calculator, :ship

      validate :ship_has_enough_fuel
      validate :not_travelling_to_same_location

      private

      def ship_has_enough_fuel
        if fuel_calculator.new_fuel_level(destination_location) < 0
          errors.add(:fuel, 'too low')
        end
      end

      def not_travelling_to_same_location
        current_location_id = ship.location.id.to_s
        destination_location_id = destination_location.id.to_s

        if current_location_id == destination_location_id
          errors.add(:destination_location, 'is same as current location')
        end
      end
    end
  end
end
