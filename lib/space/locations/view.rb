require_relative 'location_response'

module Space
  module Locations
    class View
      def initialize(location_gateway:)
        @location_gateway = location_gateway
      end

      def view(location_id)
        location = location(location_id)
        LocationResponse.new(location.id, location.name)
      end

      private

      attr_reader :location_gateway

      def location(location_id)
        location_gateway.find(location_id)
      end
    end
  end
end
