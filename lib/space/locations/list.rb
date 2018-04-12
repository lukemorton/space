module Space
  module Locations
    class List
      Response = Struct.new(:locations)

      def initialize(location_gateway:)
        @location_gateway = location_gateway
      end

      def list
        Response.new(location_gateway.all)
      end

      private

      attr_reader :location_gateway
    end
  end
end
