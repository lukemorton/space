class PeopleController < ApplicationController
  skip_before_action :redirect_if_user_does_not_have_person
  before_action :redirect_if_user_has_person

  def new
    @person = Person.new
  end

  def create
    creation = create_person_use_case.create(current_user.id, create_params)

    if creation.successful?
      redirect_to root_path
    else
      @person = creation.validator
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
    params.require(:person).permit(:name)
  end

  private

  def create_person_use_case
    Space::Folk::CreatePerson.new(
      location_gateway: location_gateway,
      person_gateway: person_gateway
    )
  end
end
