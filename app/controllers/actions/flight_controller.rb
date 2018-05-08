module Actions
  class FlightController < ApplicationController
    def travel
      travel_use_case.travel(travel_params[:ship_id], to: travel_params[:location_id])
      redirect_to ship_url(travel_params[:ship_id])
    end

    def disembark
      ship = Ship.find(disembark_params[:ship_id])
      redirect_to location_url(ship.location)
    end

    private

    def travel_use_case
      Space::Flight::Travel.new(
        location_gateway: location_gateway,
        person_gateway: person_gateway,
        ship_gateway: ship_gateway
      )
    end

    def travel_params
      params.require(:travel).permit(:ship_id, :location_id)
    end

    def disembark_params
      params.require(:disembark).permit(:ship_id)
    end
  end
end
