require 'rails_helper'

RSpec.feature 'Visiting a location' do
  scenario 'Visiting' do
    when_i_visit_a_valid_location
    then_i_should_see_its_name_and_establishments
  end

  background do
    create(:person)
  end

  given(:location) { create(:location) }

  def when_i_visit_a_valid_location
    visit location_url(location)
  end

  def then_i_should_see_its_name_and_establishments
    expect(page).to have_content(location.name)
    expect(page).to have_content('Dock')
  end
end
