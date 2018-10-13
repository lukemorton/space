require 'rails_helper'

RSpec.feature 'Requesting to board a ship' do
  scenario 'Requesting' do
    when_i_request_to_board_a_ship
    then_i_should_no_longer_be_able_to_request
  end

  background do
    person = create(:person, location: ship.location)
    sign_in create(:user, person: person)
  end

  given(:ship) { create(:ship) }

  def when_i_request_to_board_a_ship
    visit dock_url(ship.dock)
    click_button 'Request to board'
  end

  def then_i_should_no_longer_be_able_to_request
    expect(page).to_not have_button('Request to board')
  end
end
