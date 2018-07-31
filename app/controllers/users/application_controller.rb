class Users::ApplicationController < ApplicationController
  skip_before_action :redirect_if_user_does_not_have_person
end
