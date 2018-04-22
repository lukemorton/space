module Space
  module Locations
    class LocationGateway
      def initialize(location_repository:)
        @location_repository = location_repository
      end

      def all
        location_repository.all
      end

      def find(id)
        location_repository.find_by(id: id)
      end

      private

      attr_reader :location_repository
    end
  end
end
