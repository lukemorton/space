class DocksController < ApplicationController
  def show
    @dock = view_dock_use_case.view(params.fetch(:id))
  rescue Space::Locations::UnknownDockError
    raise_not_found
  end

  private

  def view_dock_use_case
    Space::Locations::ViewDock.new(
      dock_gateway: dock_gateway
    )
  end
end
