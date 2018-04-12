module Actions
  class FlightController < ApplicationController
    def travel
      use_case.travel(travel_params[:person_id], to: travel_params[:location])
      redirect_to person_url(travel_params[:person_id])
    end

    private

    def person_gateway
      Space::Flight::PersonGateway.new(person_repository: Person)
    end

    def use_case
      Space::Flight::Travel.new(person_gateway: person_gateway)
    end

    def travel_params
      params.require(:travel).permit(:person_id, :location)
    end
  end
end
