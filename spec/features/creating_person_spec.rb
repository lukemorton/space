require 'rails_helper'

RSpec.feature 'Creating person' do
  scenario 'Create' do
    when_i_create_a_person
    then_i_should_see_my_location
  end

  background do
    sign_in create(:user)
    location
  end

  given(:location) { create(:location) }

  def when_i_create_a_person
    visit root_path
    expect(page).to_not have_content(location.name)
    fill_in :person_name, with: 'Luke'
    click_button 'Create'
  end

  def then_i_should_see_my_location
    expect(page).to have_content(location.name)
  end
end
