module Space
  module Flight
    class ViewControls
      Response = Struct.new(:person, :locations)

      def initialize(person_gateway:, location_gateway:)
        @person_gateway = person_gateway
        @location_gateway = location_gateway
      end

      def view(person_id)
        Response.new(person(person_id), locations)
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
