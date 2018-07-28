class DocksController < ApplicationController
  DockViewModel = Struct.new(:id, :location, :name, :ships)

  def show
    dock = Dock.find(params.fetch(:id))
    establishment = Space::Locations::Establishment.from_object(dock)

    @dock = DockViewModel.new(
      establishment.id,
      Space::Locations::Location.from_object(dock.location),
      establishment.name,
      dock.ships.map { |ship| Space::Flight::Ship.from_object(ship) }
    )
  end
end
