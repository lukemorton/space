module Actions
  class FlightController < ApplicationController
    def travel
      use_case.travel(travel_params[:person_id], to: travel_params[:location_id])
      redirect_to ship_url(travel_params[:person_id])
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
      params.require(:travel).permit(:person_id, :location_id)
    end
  end
end
