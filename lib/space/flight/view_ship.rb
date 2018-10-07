require_relative 'list_destinations'
require_relative 'person_not_in_crew_error'
require_relative 'ship'
require_relative 'unknown_ship_error'

module Space
  module Flight
    class ViewShip
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
      Response::Destination = Struct.new(:id, :coordinates, :distance, :name, :fuel_to_travel, :within_ship_fuel_range?, :just_within_ship_fuel_range?)

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

        distance_calculator = travel_computer_factory.create_distance_calculator(ship)
        fuel_calculator = travel_computer_factory.create_fuel_calculator(ship)

        computers = Response::Computers.new(
          Response::Computer.new(fuel_calculator.name, fuel_calculator.description)
        )

        Response.new(
          ship.id,

          ship.crew,
          ship.fuel,
          ship.fuel > Ship::ALMOST_EMPTY_FUEL && ship.fuel <= Ship::LOW_FUEL,
          ship.fuel.zero?,
          ship.location,
          ship.name,
          ship.slug,

          destinations(distance_calculator, fuel_calculator, ship.location),
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

      def destinations(distance_calculator, fuel_calculator, ship_location)
        ListDestinations.new(
          distance_calculator: distance_calculator,
          fuel_calculator: fuel_calculator,
          location_gateway: location_gateway
        ).list(ship_location).destinations
      end
    end
  end
end
