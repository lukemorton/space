class ShipsController < ApplicationController
  def show
    @controls = use_case.view(params.fetch(:id), current_person.id)
    redirect_to ship_path(current_person.ship) unless @controls.person_in_crew?
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
