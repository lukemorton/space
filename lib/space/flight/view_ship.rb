require_relative 'person_not_in_crew_error'
require_relative 'unknown_ship_error'
require_relative '../locations/list'

module Space
  module Flight
    class ViewShip
      EMPTY_FUEL = 0
      ALMOST_EMPTY_FUEL = 1
      LOW_FUEL = 10

      Response = Struct.new(
        :id,

        :crew,
        :fuel,
        :low_on_fuel?,
        :out_of_fuel?,
        :location,
        :name,
        :slug,

        :destinations,
        :computers
      )
      Response::Computers = Struct.new(:fuel_calculator)
      Response::Computer = Struct.new(:name, :description)
      Response::Destination = Struct.new(:id, :coordinates, :name, :fuel_to_travel, :within_ship_fuel_range?, :just_within_ship_fuel_range?)

      def initialize(location_gateway:, person_gateway:, ship_gateway:, travel_computer_factory:)
        @location_gateway = location_gateway
        @person_gateway = person_gateway
        @ship_gateway = ship_gateway
        @travel_computer_factory = travel_computer_factory
      end

      def view(ship_slug, person_id)
        ship = ship(ship_slug)
        raise UnknownShipError.new if ship.nil?

        person = person(person_id)
        raise PersonNotInCrewError.new unless person_in_crew?(person.id, ship.crew)

        fuel_calculator = travel_computer_factory.create_fuel_calculator(ship)

        computers = Response::Computers.new(
          Response::Computer.new(fuel_calculator.name, fuel_calculator.description)
        )

        Response.new(
          ship.id,

          ship.crew,
          ship.fuel,
          ship.fuel > ALMOST_EMPTY_FUEL && ship.fuel <= LOW_FUEL,
          ship.fuel.zero?,
          ship.location,
          ship.name,
          ship.slug,

          destinations(fuel_calculator, ship.location),
          computers
        )
      end

      private

      attr_reader :location_gateway, :person_gateway, :ship_gateway, :travel_computer_factory

      def ship(ship_slug)
        ship_gateway.find_by_slug(ship_slug)
      end

      def person(person_id)
        person_gateway.find(person_id)
      end

      def person_in_crew?(person_id, crew)
        crew_ids = crew.map(&:id)
        crew_ids.include?(person_id)
      end

      def destinations(fuel_calculator, ship_location)
        locations = Locations::List.new(location_gateway: location_gateway).list.locations

        locations
          .delete_if { |destination| destination.id == ship_location.id }
          .map do |destination|
            Response::Destination.new(
              destination.id,
              destination.coordinates,
              destination.name,
              fuel_calculator.fuel_to_travel,
              fuel_calculator.new_fuel_level >= EMPTY_FUEL,
              fuel_calculator.new_fuel_level >= EMPTY_FUEL && fuel_calculator.new_fuel_level < LOW_FUEL
            )
          end
      end
    end
  end
end
