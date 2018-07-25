require 'rails_helper'

RSpec.describe 'Disembarking' do
  it 'redirects on success' do
    create(:person)
    ship = create(:ship)

    post(disembark_url, params: {
      disembark: {
        ship_id: ship.id
      }
    })

    assert_response :redirect
  end
end
