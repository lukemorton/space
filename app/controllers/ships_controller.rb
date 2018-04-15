class ShipsController < ApplicationController
  def show
    @controls = use_case.view(params.fetch(:id))
  end

  private

  def use_case
    Space::Flight::ViewControls.new(
      location_gateway: location_gateway,
      ship_gateway: ship_gateway
    )
  end
end
