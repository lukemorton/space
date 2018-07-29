require 'rails_helper'

RSpec.feature 'Boarding a ship' do
  scenario 'Boarding' do
    when_i_board_a_ship
    then_i_should_be_able_to_view_ships_controls
    and_can_navigate_to_ship_from_dock
  end

  background do
    create(:person, location: ship.location)
  end

  given(:ship) { create(:ship) }

  def when_i_board_a_ship
    visit dock_url(ship.dock)
    click_button 'Board'
  end

  def then_i_should_be_able_to_view_ships_controls
    expect(page).to have_button('Disembark')
  end

  def and_can_navigate_to_ship_from_dock
    visit dock_url(ship.dock)
    click_link ship.name
    expect(page).to have_button('Disembark')
  end
end
