require 'rails_helper'

RSpec.feature 'Cancelling request to board a ship' do
  scenario 'Cancelling' do
    when_i_cancel_my_request_to_board_a_ship
    then_i_should_be_able_to_request
  end

  background do
    person = create(:person, location: ship.location)
    sign_in create(:user, person: person)
    create(:ship_boarding_request, requester: person, ship: ship)
  end

  given(:ship) { create(:ship) }

  def when_i_cancel_my_request_to_board_a_ship
    visit dock_url(ship.dock)
    click_button 'Cancel request to board'
  end

  def then_i_should_be_able_to_request
    expect(page).to have_button('Request to board')
    expect(page).to_not have_button('Cancel request to board')
  end
end
