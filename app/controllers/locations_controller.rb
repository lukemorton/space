class LocationsController < ApplicationController
  def show
    @location = view_current_use_case.view(params.fetch(:id), current_person.id).location
  rescue Space::Locations::PersonAboardShipError
    redirect_to ship_path(current_person.ship)
  rescue Space::Locations::PersonNotInLocationError
    redirect_to location_path(current_person.location)
  rescue Space::Locations::UnknownLocationError
    raise_not_found
  end

  private

  def view_current_use_case
    Space::Locations::ViewCurrent.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end
end
