require_relative 'location'

module Space
  module Locations
    class LocationGateway
      def initialize(location_repository:)
        @location_repository = location_repository
      end

      def all
        location_repository.all.map { |location| build_location(location) }
      end

      def find(id)
        location = location_repository.find_by(id: id)
        build_location(location)
      end

      private

      attr_reader :location_repository

      def build_location(location)
        Location.new(
          id: location.id,
          establishments: location.establishments,
          name: location.name
        )
      end
    end
  end
end
