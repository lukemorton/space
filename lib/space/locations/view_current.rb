require_relative 'location_response'
require_relative 'person_not_in_location_error'
require_relative 'view'

module Space
  module Locations
    class ViewCurrent
      Response = Struct.new(:location)

      def initialize(location_gateway:, person_gateway:)
        @location_gateway = location_gateway
        @person_gateway = person_gateway
      end

      def view(location_slug, person_id)
        location = location(location_slug)
        person = person(person_id)

        if valid_location?(location.id, person.location.id)
          Response.new(location)
        else
          raise PersonNotInLocationError.new
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

      def location(location_slug)
        View.new(location_gateway: location_gateway).view(location_slug)
      end
    end
  end
end
