require 'rails_helper'

RSpec.feature 'Disembarking a ship' do
  scenario 'Disembarking' do
    when_i_dismebark_a_ship
    then_i_should_see_the_location
  end

  given(:ship) { create(:ship, :with_crew) }

  def when_i_dismebark_a_ship
    visit ship_url(ship)
    click_button 'Disembark'
  end

  def then_i_should_see_the_location
    expect(page).to have_content(ship.location.name)
  end
end
