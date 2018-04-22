require 'rails_helper'

RSpec.describe 'Location' do
  it 'renders on success' do
    location = create(:location)
    create(:person, location: location)
    get location_url(location)
    assert_response :success
  end

  it 'redirects when person isnt currently at location' do
    location = create(:location)
    create(:person, location: create(:location))
    get location_url(location)
    assert_response :redirect
  end
end
