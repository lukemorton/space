class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_person

  private

  def raise_not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def current_person
    Person.first
  end

  def dock_gateway
    Space::Locations::DockGateway.new(dock_repository: Dock)
  end

  def location_gateway
    Space::Locations::LocationGateway.new(location_repository: Location)
  end

  def person_gateway
    Space::Flight::PersonGateway.new(person_repository: Person)
  end

  def ship_gateway
    Space::Flight::ShipGateway.new(ship_repository: Ship)
  end

  def after_sign_in_path_for(resource)
    location_path current_person.location
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
