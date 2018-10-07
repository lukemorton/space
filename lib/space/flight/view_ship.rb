require_relative 'list_destinations'
require_relative 'person_not_in_crew_error'
require_relative 'ship'
require_relative 'unknown_ship_error'

module Space
  module Flight
    class ViewShip
      Response = Struct.new(
        :id,
        :computers,
        :crew,
        :destinations,
        :fuel,
        :location,
        :low_on_fuel?,
        :name,
        :out_of_fuel?,
        :slug
      )
      Response::Computers = Struct.new(:fuel_calculator)
      Response::Computer = Struct.new(:name, :description)

      def initialize(list_destinations_use_case:, person_gateway:, ship_gateway:, travel_computer_factory:)
        @list_destinations_use_case = list_destinations_use_case
        @person_gateway = person_gateway
        @ship_gateway = ship_gateway
        @travel_computer_factory = travel_computer_factory
      end

      def view(ship_slug, person_id)
        ship = ship(ship_slug)
        raise UnknownShipError.new if ship.nil?

        person = person(person_id)
        raise PersonNotInCrewError.new unless person_in_crew?(person.id, ship.crew)

        computers = build_computers(ship)

        Response.new(
          ship.id,
          build_computers(ship),
          ship.crew,
          build_destinations(ship),
          ship.fuel,
          ship.location,
          ship.fuel > Ship::ALMOST_EMPTY_FUEL && ship.fuel <= Ship::LOW_FUEL,
          ship.name,
          ship.fuel.zero?,
          ship.slug
        )
      end

      private

      attr_reader :list_destinations_use_case,
                  :person_gateway,
                  :ship_gateway,
                  :travel_computer_factory

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

      def build_computers(ship)
        fuel_calculator = travel_computer_factory.create_fuel_calculator(ship)

        Response::Computers.new(
          Response::Computer.new(fuel_calculator.name, fuel_calculator.description)
        )
      end

      def build_destinations(ship)
        list_destinations_use_case.list(ship).destinations
      end
    end
  end
end
