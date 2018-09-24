require 'rails_helper'

RSpec.feature 'Boarding a ship' do
  scenario 'Boarding' do
    when_i_board_a_ship
    then_i_should_be_able_to_view_ships_controls
  end

  background do
    person = create(:person, location: ship.location)
    sign_in create(:user, person: person)
  end

  given(:ship) { create(:ship) }

  def when_i_board_a_ship
    visit dock_url(ship.dock)
    click_button 'Board'
  end

  def then_i_should_be_able_to_view_ships_controls
    expect(page).to have_content('You boarded')
    expect(page).to have_button('Disembark')
  end
end
