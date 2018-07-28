require_relative 'location_response'
require_relative 'unknown_location_error'

module Space
  module Locations
    class View
      def initialize(location_gateway:)
        @location_gateway = location_gateway
      end

      def view(location_slug)
        location = location(location_slug)
        raise UnknownLocationError.new if location.nil?

        LocationResponse.new(
          location.id,
          location.name,
          location.establishments,
          location.slug
        )
      end

      private

      attr_reader :location_gateway

      def location(location_slug)
        location_gateway.find_by_slug(location_slug)
      end
    end
  end
end
