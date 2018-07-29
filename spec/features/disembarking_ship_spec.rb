require 'rails_helper'

RSpec.feature 'Disembarking a ship' do
  scenario 'Disembarking' do
    when_i_disembark_a_ship
    then_i_should_see_a_list_of_places_to_visit
    and_i_should_no_longer_be_able_to_travel
  end

  background do
    # create(:person)
  end

  given(:ship) { create(:ship, :with_crew) }

  def when_i_disembark_a_ship
    visit ship_url(ship)
    click_button 'Disembark'
  end

  def then_i_should_see_a_list_of_places_to_visit
    expect(page).to have_content('You disembarked')
    expect(page).to have_content(ship.location.name)
    expect(page).to have_content('Dock')
  end

  def and_i_should_no_longer_be_able_to_travel
    visit ship_url(ship)
    expect(page).not_to have_button('Travel')
  end
end
