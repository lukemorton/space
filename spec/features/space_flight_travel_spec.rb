require 'rails_helper'

RSpec.feature 'Space flight travel' do
  scenario 'Before travelling' do
    when_viewing_controls
    then_my_current_location_should_be_selected
  end

  scenario 'Travelling' do
    when_i_travel_to_a_valid_location
    then_my_location_should_be_updated
  end

  background do
    create_locations
  end

  given(:location) { create(:location) }
  given(:new_location) { create(:location, name: 'New location') }
  given(:person) { create(:person, location: location.name) }

  def when_viewing_controls
    visit person_url(person)
  end

  def then_my_current_location_should_be_selected
    expect(page).to have_css('input[type=radio][checked]')
  end

  def when_i_travel_to_a_valid_location
    visit person_url(person)
    choose new_location.name
    click_button
  end

  def then_my_location_should_be_updated
    expect(page).to have_content(new_location.name)
  end

  private

  def create_locations
    create(:location)
    new_location
  end
end
