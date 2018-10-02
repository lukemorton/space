require_relative 'person_not_in_crew_error'
require_relative 'unknown_ship_error'
require_relative '../locations/list'

module Space
  module Flight
    class ViewShip
      Response = Struct.new(
        :id,

        :crew,
        :fuel,
        :location,
        :name,
        :slug,

        :destinations,
        :computers
      )
      Response::Computers = Struct.new(:fuel_calculator, :travel_validator)
      Response::Computer = Struct.new(:name, :description)

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
          ship.location,
          ship.name,
          ship.slug,

          destinations,
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

      def destinations
        Locations::List.new(location_gateway: location_gateway).list.locations
      end
    end
  end
end
