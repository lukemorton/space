require 'rails_helper'

RSpec.feature 'Visiting a Dock' do
  scenario 'Visiting' do
    when_i_visit_a_valid_dock
    then_i_should_see_its_name
  end

  background do
    create(:person)
    ship
  end

  given(:dock) { create(:dock) }
  given(:ship) { create(:ship, location: dock.location) }

  def when_i_visit_a_valid_dock
    visit dock_url(dock)
  end

  def then_i_should_see_its_name
    expect(page).to have_content(dock.location.name)
    expect(page).to have_content('Dock')
  end
end
