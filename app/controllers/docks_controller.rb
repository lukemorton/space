class DocksController < ApplicationController
  def show
    @dock = view_dock_use_case.view(params.fetch(:id))
  end

  private

  def view_dock_use_case
    Space::Locations::ViewDock.new
  end
end
