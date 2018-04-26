class DocksController < ApplicationController
  def show
    @dock = Dock.find(params.fetch(:id))
  end
end
