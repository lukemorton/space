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
    create(:person, location: location, ship: ship)
    new_location
  end

  given(:location) { create(:location) }
  given(:new_location) { create(:location, name: 'New location') }
  given(:ship) { create(:ship, location: location) }

  def when_viewing_controls
    visit ship_url(ship)
  end

  def then_my_current_location_should_be_selected
    expect(page).to have_css('input[type=radio][checked]')
  end

  def when_i_travel_to_a_valid_location
    visit ship_url(ship)
    choose new_location.name
    click_button 'Travel'
  end

  def then_my_location_should_be_updated
    expect(page).to have_content(new_location.name)
  end
end
