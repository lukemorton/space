require 'active_model'

module Space
  module Computers
    class BasicTravelValidator
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
