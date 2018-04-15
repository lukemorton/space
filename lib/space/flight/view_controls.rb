require_relative '../locations/list'

module Space
  module Flight
    class ViewControls
      Response = Struct.new(:ship, :person, :locations)

      def initialize(location_gateway:, ship_gateway:)
        @location_gateway = location_gateway
        @ship_gateway = ship_gateway
      end

      def view(ship_id)
        ship = ship(ship_id)
        Response.new(ship, person(ship), locations)
      end

      private

      attr_reader :location_gateway, :ship_gateway

      def ship(ship_id)
        ship_gateway.find(ship_id)
      end

      def person(ship)
        ship.crew.first
      end

      def locations
        Locations::List.new(location_gateway: location_gateway).list.locations
      end
    end
  end
end
