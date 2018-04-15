class LocationsController < ApplicationController
  def show
    @location = use_case.view(params.fetch(:id))
  end

  private

  def use_case
    Space::Locations::View.new(
      location_gateway: location_gateway
    )
  end
end
