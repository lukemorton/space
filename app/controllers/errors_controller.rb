class ErrorsController < ApplicationController
  def not_found
    render_not_found
  end

  def unprocessable_entity
    render_unprocessable_entity
  end
end
