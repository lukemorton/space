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

      def initialize(travel_computer_factory:, location_gateway:)
        @travel_computer_factory = travel_computer_factory
        @location_gateway = location_gateway
      end

      def list(ship)
        Response.new(
          location_gateway.all
            .delete_if { |destination| destination.id == ship.location.id }
            .map { |destination| build_destination(destination, ship) }
            .sort_by { |destination| destination.fuel_to_travel }
        )
      end

      private

      attr_reader :travel_computer_factory
      attr_reader :location_gateway

      def build_destination(destination, ship)
        new_fuel_level = fuel_calculator(ship).new_fuel_level(destination)

        Response::Destination.new(
          destination.id,
          destination.coordinates,
          distance_calculator(ship).distance_between(ship.location, destination),
          destination.name,
          fuel_calculator(ship).fuel_to_travel(destination),
          new_fuel_level >= Ship::EMPTY_FUEL,
          new_fuel_level >= Ship::EMPTY_FUEL && new_fuel_level < Ship::LOW_FUEL
        )
      end

      def distance_calculator(ship)
        travel_computer_factory.create_distance_calculator(ship)
      end

      def fuel_calculator(ship)
        travel_computer_factory.create_fuel_calculator(ship)
      end
    end
  end
end
