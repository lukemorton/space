class ShipsController < ApplicationController
  def show
    @controls = use_case.view(params.fetch(:id), current_person.id)
  rescue Space::Flight::PersonNotInCrewError
    redirect_to current_person.location
  rescue Space::Flight::UnknownShipError
    raise_not_found
  end

  private

  def use_case
    Space::Flight::ViewControls.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway,
      ship_gateway: ship_gateway
    )
  end
end
