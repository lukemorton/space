class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def location_gateway
    Space::Locations::LocationGateway.new(location_repository: Location)
  end

  def person_gateway
    Space::Flight::PersonGateway.new(person_repository: Person)
  end
end
