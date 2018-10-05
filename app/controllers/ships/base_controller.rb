class Ships::BaseController < ApplicationController
  before_action :load_ship

  private

  def load_ship
    @ship = ShipPresenter.new(
      view_controls_use_case.view(params.fetch(:ship_id), current_person.id)
    )
  rescue Space::Flight::PersonNotInCrewError
    redirect_to location_path(current_person.location)
  rescue Space::Flight::UnknownShipError
    render_not_found
  end

  def view_controls_use_case
    Space::Flight::ViewShip.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway,
      ship_gateway: ship_gateway,
      travel_computer_factory: travel_computer_factory
    )
  end
end