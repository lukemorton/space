class Ships::DockServicesController < Ships::BaseController
  def index
    @dock_services = ShipDockServicesPresenter.new(
      view_dock_services_use_case.view(params.fetch(:ship_id), current_person.id)
    )
  end

  private

  def view_dock_services_use_case
    Space::Flight::ViewDockServices.new(
      money_gateway: money_gateway,
      person_gateway: person_gateway,
      ship_gateway: ship_gateway
    )
  end
end
