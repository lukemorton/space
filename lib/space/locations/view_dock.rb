require_relative 'unknown_dock_error'

module Space
  module Locations
    class ViewDock
      Response = Struct.new(:id, :location, :name, :ships, :to_param)

      def initialize(dock_gateway:)
        @dock_gateway = dock_gateway
      end

      def view(dock_slug)
        dock = dock_gateway.find_by_slug(dock_slug)
        raise Space::Locations::UnknownDockError.new if dock.nil?
        
        Response.new(
          dock.id,
          dock.location,
          dock.name,
          dock.ships,
          dock.slug
        )
      end

      private

      attr_reader :dock_gateway
    end
  end
end
