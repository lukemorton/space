class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :redirect_if_user_does_not_have_person
  helper_method :current_person
  rescue_from StandardError, with: :render_internal_server_error unless Rails.env.test?

  private

  def render_internal_server_error(error)
    if error.nil?
      @error_reference = params[:error_reference]
    else
      Raven.capture_exception(error, user: { id: current_user&.id, email: current_user&.email })
      Rails.logger.error(error)
      @error_reference = Raven.last_event_id
    end

    render 'errors/500', status: :internal_server_error
  end

  def render_not_found(error)
    Rails.logger.debug(error) unless error.nil?
    render 'errors/404', status: :not_found
  end

  def render_unprocessable_entity(error)
    Rails.logger.debug(error) unless error.nil?
    render 'errors/422', status: :unprocessable_entity
  end

  def redirect_if_user_does_not_have_person
    redirect_to new_person_path unless current_user&.person.present?
  end

  def user_has_character?
    current_person.present?
  end

  def current_person
    @current_person ||= begin
      return unless current_user&.person

      view_hud_use_case = Space::Folk::ViewHud.new(
        money_gateway: money_gateway,
        person_gateway: person_gateway
      )

      CurrentPersonPresenter.new(
        view_hud_use_case.view(current_user.person.id)
      )
    end
  end

  def dock_gateway
    Space::Locations::DockGateway.new(dock_repository: Dock)
  end

  def location_gateway
    Space::Locations::LocationGateway.new(location_repository: Location)
  end

  def money_gateway
    Space::Folk::MoneyGateway.new(
      double_entry: DoubleEntry
    )
  end

  def person_gateway
    Space::Folk::PersonGateway.new(person_repository: Person)
  end

  def ship_gateway
    Space::Flight::ShipGateway.new(ship_repository: Ship)
  end

  def ship_boarding_request_gateway
    Space::Flight::ShipBoardingRequestGateway.new(ship_boarding_request_repository: ShipBoardingRequest)
  end

  def travel_computer_factory
    Space::Flight::TravelComputerFactory.new
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
