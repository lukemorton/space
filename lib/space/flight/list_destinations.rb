require_relative 'ship'

module Space
  module Flight
    class ListDestinations
      Response = Struct.new(:destinations)
      Response::Destination = Struct.new(
        :id,
        :coordinates,
        :distance,
        :name,
        :fuel_to_travel,
        :within_ship_fuel_range?,
        :just_within_ship_fuel_range?
      )

      def initialize(distance_calculator:, fuel_calculator:, location_gateway:)
        @distance_calculator = distance_calculator
        @fuel_calculator = fuel_calculator
        @location_gateway = location_gateway
      end

      def list(current_location)
        Response.new(
          location_gateway.all
            .delete_if { |destination| destination.id == current_location.id }
            .map { |destination| build_destination(destination, current_location) }
            .sort_by { |destination| destination.fuel_to_travel }
        )
      end

      private

      attr_reader :distance_calculator
      attr_reader :fuel_calculator
      attr_reader :location_gateway

      def build_destination(destination, current_location)
        new_fuel_level = fuel_calculator.new_fuel_level(destination)

        Response::Destination.new(
          destination.id,
          destination.coordinates,
          distance_calculator.distance_between(current_location, destination),
          destination.name,
          fuel_calculator.fuel_to_travel(destination),
          new_fuel_level >= Ship::EMPTY_FUEL,
          new_fuel_level >= Ship::EMPTY_FUEL && new_fuel_level < Ship::LOW_FUEL
        )
      end
    end
  end
end
