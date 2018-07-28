require_relative 'location'

module Space
  module Locations
    class LocationGateway
      def initialize(location_repository:)
        @location_repository = location_repository
      end

      def all
        location_repository.all.map { |location| Location.from_object(location) }
      end

      def find(id)
        location = location_repository.find(id)
        Location.from_object(location)
      end

      private

      attr_reader :location_repository
    end
  end
end
