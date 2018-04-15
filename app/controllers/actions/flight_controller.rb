module Actions
  class FlightController < ApplicationController
    def travel
      use_case.travel(travel_params[:ship_id], to: travel_params[:location_id])
      redirect_to ship_url(travel_params[:ship_id])
    end

    private

    def use_case
      Space::Flight::Travel.new(
        location_gateway: location_gateway,
        person_gateway: person_gateway,
        ship_gateway: ship_gateway
      )
    end

    def travel_params
      params.require(:travel).permit(:ship_id, :location_id)
    end
  end
end
