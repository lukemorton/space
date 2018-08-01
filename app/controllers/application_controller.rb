class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :redirect_if_user_does_not_have_person
  helper_method :current_person

  private

  def raise_not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def redirect_if_user_does_not_have_person
    redirect_to new_person_path unless current_user&.person.present?
  end

  def user_has_character?
    current_person.present?
  end

  def current_person
    current_user&.person
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
    if user_has_character?
      location_path current_person.location
    else
      new_person_path
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
