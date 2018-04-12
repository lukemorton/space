class PeopleController < ApplicationController
  def show
    @person = Person.find(params.fetch(:id))
  end
end
