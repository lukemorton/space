class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def person_gateway
    Space::Flight::PersonGateway.new(person_repository: Person)
  end
end
