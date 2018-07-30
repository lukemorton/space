class PeopleController < ApplicationController
  def new
    @person = Person.new
  end

  def create
    @person = Person.new(create_params)

    if @person.valid?
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:person).permit(:name).merge(
      location: Location.first,
      user: current_user
    )
  end
end
