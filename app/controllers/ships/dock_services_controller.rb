class Ships::DockServicesController < Ships::BaseController
  def index
    @dock_services = ShipDockServicesPresenter.new(current_person)
  end
end
