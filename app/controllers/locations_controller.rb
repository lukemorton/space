class LocationsController < ApplicationController
  def show
    @location = location
  rescue Space::Locations::PersonNotInLocationError
    redirect_to location_path(current_person.location_id)
  rescue Space::Locations::UnknownLocationError
    raise_not_found
  end

  private

  def use_case
    Space::Locations::ViewCurrent.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end

  def current_location_response
    @current_location_response ||= use_case.view(params.fetch(:id), current_person.id)
  end

  def person_is_currently_at_location?
    current_location_response.current?
  end

  def location
    current_location_response.location
  end
end
