class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_person

  private

  def current_person
    Person.first
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
end
