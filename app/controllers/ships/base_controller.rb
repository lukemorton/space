class Ships::BaseController < ApplicationController
  before_action :load_ship

  private

  def load_ship
    @ship = ShipPresenter.new(
      view_controls_use_case.view(params.fetch(:ship_id), current_person.id)
    )
  rescue Space::Flight::PersonNotInCrewError
    redirect_to location_path(current_person.location)
  rescue Space::Flight::UnknownShipError => e
    render_not_found(e)
  end

  def view_controls_use_case
    Space::Flight::ViewShip.new(
      list_destinations_use_case: list_destinations_use_case,
      person_gateway: person_gateway,
      ship_gateway: ship_gateway,
      travel_computer_factory: travel_computer_factory
    )
  end

  def list_destinations_use_case
    Space::Flight::ListDestinations.new(
      travel_computer_factory: travel_computer_factory,
      location_gateway: location_gateway
    )
  end
end
