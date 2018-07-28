module Space
  module Locations
    class ViewDock
      Response = Struct.new(:id, :location, :name, :ships)

      def view(dock_id)
        dock = ::Dock.find(dock_id)
        establishment = Space::Locations::Establishment.from_object(dock)

        Response.new(
          establishment.id,
          Space::Locations::Location.from_object(dock.location),
          establishment.name,
          dock.ships.map { |ship| Space::Flight::Ship.from_object(ship) }
        )
      end
    end
  end
end
