require_relative 'location_response'
require_relative 'unknown_location_error'

module Space
  module Locations
    class View
      def initialize(location_gateway:)
        @location_gateway = location_gateway
      end

      def view(location_id)
        location = location(location_id)
        raise UnknownLocationError.new if location.nil?

        LocationResponse.new(
          location.id,
          location.name,
          location.establishments,
          location.dock
        )
      end

      private

      attr_reader :location_gateway

      def location(location_id)
        location_gateway.find(location_id)
      end
    end
  end
end
