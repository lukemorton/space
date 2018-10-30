class Ships::CrewController < Ships::BaseController
  def index
    @crew_overview = view_crew_overview_use_case.view(params.fetch(:ship_id), current_person.id)
  end

  private

  def view_crew_overview_use_case
    Space::Flight::ViewCrewOverview.new(
      person_gateway: person_gateway,
      ship_gateway: ship_gateway
    )
  end
end
