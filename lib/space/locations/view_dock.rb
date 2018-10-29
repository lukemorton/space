require_relative 'view_current'
require_relative 'unknown_dock_error'

module Space
  module Locations
    class ViewDock
      Response = Struct.new(:id, :location, :name, :ships, :slug, :to_param)
      Response::Ship = Struct.new(:id, :name, :crew, :has_boarding_request_from_current_person?, :slug, :to_param)

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
          dock.ships.map { |ship| build_ship(ship, person_id) },
          dock.slug,
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

      def ship_has_boarding_request_from_person?(ship, person_id)
        ship.boarding_requests.any? { |boarding_request| boarding_request.requester_id == person_id }
      end

      def build_ship(ship, person_id)
        Response::Ship.new(
          ship.id,
          ship.name,
          ship.crew,
          ship_has_boarding_request_from_person?(ship, person_id),
          ship.slug,
          ship.slug
        )
      end
    end
  end
end
