require 'rails_helper'

RSpec.feature 'Space flight travel' do
  scenario 'Travelling' do
    when_i_travel_to_a_valid_location
    then_my_location_should_be_updated
  end

  given(:person) { create(:person) }

  def when_i_travel_to_a_valid_location
    visit person_url(person)
    fill_in :travel_location, with: 'New location'
    click_button
  end

  def then_my_location_should_be_updated
    expect(person.reload.location).to eq('New location')
  end
end
