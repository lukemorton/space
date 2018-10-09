class DocksController < ApplicationController
  def show
    @dock = view_dock_use_case.view(params.fetch(:id), current_person.id)
  rescue Space::Locations::PersonAboardShipError
    redirect_to ship_path(current_person.ship)
  rescue Space::Locations::PersonNotInLocationError
    redirect_to location_path(current_person.location)
  rescue Space::Locations::UnknownDockError => e
    render_not_found(e)
  end

  private

  def view_dock_use_case
    Space::Locations::ViewDock.new(
      dock_gateway: dock_gateway,
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end
end
