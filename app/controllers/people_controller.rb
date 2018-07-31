class PeopleController < ApplicationController
  before_action :redirect_if_user_has_person

  def new
    @person = Person.new
  end

  def create
    @person = Person.create(create_params)

    if @person.valid?
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def redirect_if_user_has_person
    if current_user.person.present?
      redirect_to root_path
    end
  end

  def create_params
    params.require(:person).permit(:name).merge(
      location: Location.first,
      user: current_user
    )
  end
end
