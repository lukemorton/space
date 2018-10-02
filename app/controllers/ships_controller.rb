class ShipsController < ApplicationController
  def show
    @controls = ship_presenter
  rescue Space::Flight::PersonNotInCrewError
    redirect_to current_person.location
  rescue Space::Flight::UnknownShipError
    raise_not_found
  end

  private

  def ship_presenter
    response = view_controls_use_case.view(params.fetch(:id), current_person.id)
    ShipPresenter.new(response.to_h)
  end

  def view_controls_use_case
    Space::Flight::ViewControls.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway,
      ship_gateway: ship_gateway,
      travel_computer_factory: travel_computer_factory
    )
  end
end
