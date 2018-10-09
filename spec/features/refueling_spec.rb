require 'rails_helper'

RSpec.feature 'Refueling a ship' do
  scenario 'Refuel fully' do
    when_i_refuel_my_ship_fully
    then_i_should_be_fully_refueled
  end

  scenario 'Refuel half tank' do
    when_i_refuel_my_ship_half_full
    then_i_should_be_half_refueled
  end

  given(:ship) { create(:ship, :with_crew) }
  given(:person) { create(:person, location: ship.location, ship: ship) }

  background do
    sign_in create(:user, person: person)
  end

  def when_i_refuel_my_ship_fully
    visit ship_dock_services_url(ship)
    choose 'Full tank'
    click_button 'Purchase'
  end

  def then_i_should_be_fully_refueled
    expect(page).to have_content('Refuel')
    expect(page).to have_content('Fuel 5,000')
  end

  def when_i_refuel_my_ship_half_full
    visit ship_dock_services_url(ship)
    choose 'Half tank'
    click_button 'Purchase'
  end

  def then_i_should_be_half_refueled
    expect(page).to have_content('Refuel')
    expect(page).to have_content('Fuel 2,500')
  end
end
