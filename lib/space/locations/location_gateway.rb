require_relative 'location'

module Space
  module Locations
    class LocationGateway
      def initialize(location_repository:)
        @location_repository = location_repository
      end

      def all
        location_repository.all.includes(:establishments).map { |location| Location.from_object(location) }
      end

      def find(id)
        location = location_repository.find_by(id: id)
        Space::Locations::Location.from_object(location) unless location.nil?
      end

      def find_by_slug(slug)
        location = location_repository.find_by(slug: slug)
        Space::Locations::Location.from_object(location) unless location.nil?
      end

      private

      attr_reader :location_repository
    end
  end
end
