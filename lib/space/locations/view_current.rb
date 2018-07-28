require_relative 'location_response'
require_relative 'view'

module Space
  module Locations
    class ViewCurrent
      Response = Struct.new(:current?, :location)

      def initialize(location_gateway:, person_gateway:)
        @location_gateway = location_gateway
        @person_gateway = person_gateway
      end

      def view(location_id, person_id)
        location = location(location_id)
        person = person(person_id)

        if valid_location?(location.id, person.location.id)
          Response.new(true, location)
        else
          Response.new(false)
        end
      end

      private

      attr_reader :location_gateway, :person_gateway

      def valid_location?(location_id, person_location_id)
        location_id == person_location_id
      end

      def person(person_id)
        person_gateway.find(person_id)
      end

      def location(location_id)
        View.new(location_gateway: location_gateway).view(location_id)
      end
    end
  end
end
