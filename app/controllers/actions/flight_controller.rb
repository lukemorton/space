module Actions
  class FlightController < ApplicationController
    def travel
      ship = Ship.find(travel_params[:ship_id])
      travel_use_case.travel(travel_params[:ship_id], to: travel_params[:location_id])
      redirect_to ship_url(ship)
    end

    def disembark
      disembark_use_case.disembark(current_person.id, disembark_params[:ship_id])
      redirect_to location_url(current_person.location)
    end

    private

    def travel_use_case
      Space::Flight::Travel.new(
        location_gateway: location_gateway,
        person_gateway: person_gateway,
        ship_gateway: ship_gateway
      )
    end

    def disembark_use_case
      Space::Flight::Disembark.new(
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
