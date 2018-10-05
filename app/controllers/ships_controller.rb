class ShipsController < ApplicationController
  def show
    redirect_to ship_flight_deck_path(params.fetch(:id))
  end
end
