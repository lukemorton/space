module Space
  module Flight
    class ListDestinations
      Response = Struct.new(:locations)
      LocationResponse = Struct.new(:id, :coordinates, :name, :establishments, :to_param)

      def initialize(location_gateway:)
        @location_gateway = location_gateway
      end

      def list
        Response.new(
          location_gateway.all.map do |location|
            LocationResponse.new(location.id, location.coordinates, location.name, [])
          end
        )
      end

      private

      attr_reader :location_gateway
    end
  end
end
