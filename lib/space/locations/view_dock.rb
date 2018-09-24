require_relative 'view_current'
require_relative 'unknown_dock_error'

module Space
  module Locations
    class ViewDock
      Response = Struct.new(:id, :location, :name, :ships, :to_param)

      def initialize(dock_gateway:, location_gateway:, person_gateway:)
        @dock_gateway = dock_gateway
        @location_gateway = location_gateway
        @person_gateway = person_gateway
      end

      def view(dock_slug, person_id)
        dock = dock_gateway.find_by_slug(dock_slug)
        raise Space::Locations::UnknownDockError.new if dock.nil?
        ensure_person_in_location(dock.location.slug, person_id)

        Response.new(
          dock.id,
          dock.location,
          dock.name,
          dock.ships,
          dock.slug
        )
      end

      private

      attr_reader :dock_gateway, :location_gateway, :person_gateway

      def view_current_use_case
        ViewCurrent.new(
          location_gateway: location_gateway,
          person_gateway: person_gateway
        )
      end

      def ensure_person_in_location(location_slug, person_id)
        view_current_use_case.view(location_slug, person_id)
      end
    end
  end
end
