module Space
  module Locations
    class List
      def initialize(location_gateway:)
        @location_gateway = location_gateway
      end

      def list
        location_gateway.all
      end

      private

      attr_reader :location_gateway
    end
  end
end
