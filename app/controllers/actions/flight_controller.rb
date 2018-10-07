module Actions
  class FlightController < ApplicationController
    def board
      board_use_case.board(current_person.id, board_params.fetch(:ship_id))
      flash[:success] = 'You boarded'
      redirect_to ship_url(board_params[:ship_slug])
    end

    def disembark
      disembark_use_case.disembark(current_person.id, disembark_params.fetch(:ship_id))
      flash[:success] = 'You disembarked'
      redirect_to location_url(current_person.location)
    end

    def travel
      travelling = travel_use_case.travel(travel_params.fetch(:ship_id), to: travel_params.fetch(:location_id))
      flash[:success] = 'You travelled'
      redirect_to ship_url(travel_params[:ship_slug])
    rescue Space::Flight::InvalidTravelError
      render_unprocessable_entity
    end

    private

    def board_use_case
      Space::Flight::Board.new(
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

    def board_params
      params.require(:board).permit(:ship_id, :ship_slug)
    end

    def disembark_params
      params.require(:disembark).permit(:ship_id)
    end

    def travel_params
      params.require(:travel).permit(:ship_id, :ship_slug, :location_id)
    end
  end
end
