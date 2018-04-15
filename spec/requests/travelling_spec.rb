require 'rails_helper'

RSpec.describe 'Travelling' do
  it 'redirects on success' do
    ship = create(:ship)
    location = create(:location)

    post(travel_url, params: {
      travel: {
        ship_id: ship.id,
        location_id: location.id
      }
    })

    assert_response :redirect
  end
end
