class LocationsController < ApplicationController
  def show
    @location = view_current_use_case.view(params.fetch(:id), current_person.id).location
  rescue Space::Locations::PersonAboardShipError
    redirect_to current_person.ship
  rescue Space::Locations::PersonNotInLocationError
    redirect_to current_person.location
  rescue Space::Locations::UnknownLocationError
    render_not_found
  end

  private

  def view_current_use_case
    Space::Locations::ViewCurrent.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end
end
