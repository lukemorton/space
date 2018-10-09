class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :redirect_if_user_does_not_have_person

  def internal_server_error
    render_internal_server_error(nil)
  end

  def not_found
    render_not_found(nil)
  end

  def unprocessable_entity
    render_unprocessable_entity(nil)
  end
end
