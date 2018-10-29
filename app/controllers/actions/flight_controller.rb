module Actions
  class FlightController < ApplicationController
    rescue_from Space::Flight::UnknownShipError,
                Space::Locations::UnknownLocationError,
                with: :render_unprocessable_entity

    def board
      request = request_to_board_use_case.request(board_params.fetch(:ship_id), current_person.id)

      if request.rejected_as_already_in_crew?
        flash[:errors] = request.errors
        redirect_to ship_url(board_params[:ship_slug])
      else
        redirect_to dock_url(board_params[:dock_slug])
      end
    end

    def disembark
      disembarking = disembark_use_case.disembark(current_person.id, disembark_params.fetch(:ship_id))

      if disembarking.successful?
        flash[:success] = 'You disembarked'
      else
        flash[:errors] = disembarking.errors
      end

      redirect_to location_url(current_person.location)
    end

    def refuel
      refuel_use_case.refuel(refuel_params.fetch(:ship_id), current_person: current_person.id, refuel: refuel_params.fetch(:refuel))
      redirect_to ship_dock_services_url(refuel_params.fetch(:ship_slug))
    end

    def travel
      travelling = travel_use_case.travel(travel_params.fetch(:ship_id), current_person: current_person.id, to: travel_params.fetch(:location_id))

      if travelling.successful?
        flash[:success] = 'You travelled'
      else
        flash[:errors] = travelling.errors
      end

      redirect_to ship_url(travel_params.fetch(:ship_slug))
    end

    private

    def board_use_case
      Space::Flight::Board.new(
        ship_gateway: ship_gateway
      )
    end

    def request_to_board_use_case
      Space::Flight::RequestToBoard.new(
        ship_boarding_request_gateway: ship_boarding_request_gateway,
        ship_gateway: ship_gateway
      )
    end

    def disembark_use_case
      Space::Flight::Disembark.new(
        ship_gateway: ship_gateway
      )
    end

    def travel_use_case
      Space::Flight::Travel.new(
        location_gateway: location_gateway,
        person_gateway: person_gateway,
        ship_gateway: ship_gateway,
        travel_computer_factory: travel_computer_factory
      )
    end

    def refuel_use_case
      Space::Flight::Refuel.new(
        money_gateway: money_gateway,
        person_gateway: person_gateway,
        ship_gateway: ship_gateway
      )
    end

    def board_params
      params.require(:board).permit(:ship_id, :ship_slug, :dock_slug)
    end

    def disembark_params
      params.require(:disembark).permit(:ship_id)
    end

    def refuel_params
      params.require(:refuel).permit(:ship_id, :ship_slug, :refuel)
    end

    def travel_params
      params.require(:travel).permit(:ship_id, :ship_slug, :location_id)
    end
  end
end
