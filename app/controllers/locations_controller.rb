class LocationsController < ApplicationController
  def show
    if person_is_currently_at_location?
      @location = location
    else
      redirect_to location_path(current_person.location_id)
    end
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
