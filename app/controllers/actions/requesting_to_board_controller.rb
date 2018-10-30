module Actions
  class RequestingToBoardController < ApplicationController
    rescue_from Space::Flight::UnknownShipError,
                Space::Flight::AlreadyHasRequestToBoardError,
                with: :render_unprocessable_entity

    def request_to_board
      request = request_to_board_use_case.request(request_to_board_params.fetch(:ship_id), current_person.id)

      if request.rejected_as_already_in_crew?
        flash[:errors] = request.errors
        redirect_to ship_url(request_to_board_params[:ship_slug])
      else
        redirect_to dock_url(request_to_board_params[:dock_slug])
      end
    end

    def cancel_boarding_request
      cancel_request_to_board_use_case.cancel(cancel_boarding_request_params.fetch(:id), current_person.id)
      redirect_to dock_url(cancel_boarding_request_params[:dock_slug])
    end

    private

    def request_to_board_use_case
      Space::Flight::RequestToBoard.new(
        ship_boarding_request_gateway: ship_boarding_request_gateway,
        ship_gateway: ship_gateway
      )
    end

    def cancel_request_to_board_use_case
      Space::Flight::CancelRequestToBoard.new(
        ship_boarding_request_gateway: ship_boarding_request_gateway
      )
    end

    def request_to_board_params
      params.require(:board).permit(:ship_id, :ship_slug, :dock_slug)
    end

    def cancel_boarding_request_params
      params.require(:ship_boarding_request).permit(:id, :dock_slug)
    end
  end
end
