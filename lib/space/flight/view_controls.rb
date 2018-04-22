require_relative '../locations/list'

module Space
  module Flight
    class ViewControls
      Response = Struct.new(:person_in_crew?, :ship, :person, :locations)

      def initialize(location_gateway:, person_gateway:, ship_gateway:)
        @location_gateway = location_gateway
        @person_gateway = person_gateway
        @ship_gateway = ship_gateway
      end

      def view(ship_id, person_id)
        ship = ship(ship_id)
        person = person(person_id)
        Response.new(person_in_crew?(person, ship.crew), ship, person, locations)
      end

      private

      attr_reader :location_gateway, :person_gateway, :ship_gateway

      def ship(ship_id)
        ship_gateway.find(ship_id)
      end

      def person(person_id)
        person_gateway.find(person_id)
      end

      def person_in_crew?(person, crew)
        crew.include?(person)
      end

      def locations
        Locations::List.new(location_gateway: location_gateway).list.locations
      end
    end
  end
end
