require_relative '../locations/list'

module Space
  module Flight
    class ViewControls
      Response = Struct.new(:ship, :person, :locations)
      Ship = Struct.new(:id)

      def initialize(person_gateway:, location_gateway:)
        @person_gateway = person_gateway
        @location_gateway = location_gateway
      end

      def view(ship_id)
        Response.new(Ship.new(ship_id), person(ship_id), locations)
      end

      private

      attr_reader :person_gateway, :location_gateway

      def person(person_id)
        person_gateway.find(person_id)
      end

      def locations
        Locations::List.new(location_gateway: location_gateway).list.locations
      end
    end
  end
end
