require_relative 'person_not_in_crew_error'
require_relative 'unknown_ship_error'
require_relative '../locations/list'

module Space
  module Flight
    class ViewControls
      Response = Struct.new(:ship, :person, :locations)

      def initialize(location_gateway:, person_gateway:, ship_gateway:)
        @location_gateway = location_gateway
        @person_gateway = person_gateway
        @ship_gateway = ship_gateway
      end

      def view(ship_slug, person_id)
        ship = ship(ship_slug)
        raise UnknownShipError.new if ship.nil?
        person = person(person_id)
        raise PersonNotInCrewError.new unless person_in_crew?(person.id, ship.crew)
        Response.new(ship, person, locations)
      end

      private

      attr_reader :location_gateway, :person_gateway, :ship_gateway

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

      def locations
        Locations::List.new(location_gateway: location_gateway).list.locations
      end
    end
  end
end
