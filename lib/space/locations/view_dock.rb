require_relative 'unknown_dock_error'

module Space
  module Locations
    class ViewDock
      Response = Struct.new(:id, :location, :name, :ships)

      def initialize(dock_gateway:)
        @dock_gateway = dock_gateway
      end

      def view(dock_id)
        dock = dock_gateway.find(dock_id)
        raise Space::Locations::UnknownDockError.new if dock.nil?
        
        Response.new(
          dock.id,
          dock.location,
          dock.name,
          dock.ships
        )
      end

      private

      attr_reader :dock_gateway
    end
  end
end
