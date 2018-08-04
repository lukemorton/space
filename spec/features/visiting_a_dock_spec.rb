require 'rails_helper'

RSpec.feature 'Visiting a Dock' do
  scenario 'Visiting' do
    when_i_visit_a_valid_dock
    then_i_should_see_its_name_and_have_ships_listed
  end

  background do
    sign_in create(:user, :with_person)
    ship
  end

  given(:dock) { create(:dock, name: 'London Dock') }
  given(:ship) { create(:ship, :with_crew, dock: dock) }

  def when_i_visit_a_valid_dock
    visit dock_url(dock)
  end

  def then_i_should_see_its_name_and_have_ships_listed
    expect(page).to have_content(dock.location.name)
    expect(page).to have_content(dock.name)
    expect(page).to have_content(ship.name)
    expect(page).to have_content(ship.crew.map(&:name).join(','))
  end
end
