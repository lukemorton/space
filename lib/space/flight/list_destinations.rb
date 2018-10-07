module Space
  module Flight
    class ListDestinations
      Response = Struct.new(:destinations)
      Response::Destination = Struct.new(:id, :coordinates, :name)

      def initialize(location_gateway:)
        @location_gateway = location_gateway
      end

      def list(current_location)
        Response.new(
          location_gateway.all
            .delete_if { |destination| destination.id == current_location.id }
            .map do |destination|
              Response::Destination.new(destination.id, destination.coordinates, destination.name)
            end
        )
      end

      private

      attr_reader :location_gateway
    end
  end
end
