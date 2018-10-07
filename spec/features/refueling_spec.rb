require 'rails_helper'

RSpec.feature 'Refueling a ship' do
  scenario 'Refuel' do
    when_i_refuel_my_ship
    then_i_should_see_dock_services
  end

  given(:ship) { create(:ship, :with_crew) }
  given(:person) { create(:person, location: ship.location, ship: ship) }

  background do
    sign_in create(:user, person: person)
  end

  def when_i_refuel_my_ship
    visit ship_dock_services_url(ship)
    click_button 'Purchase'
  end

  def then_i_should_see_dock_services
    expect(page).to have_content('Refuel')
  end
end
