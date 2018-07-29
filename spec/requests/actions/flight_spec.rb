require 'rails_helper'

RSpec.describe Actions::FlightController do
  describe '#board' do
    it 'redirects on success' do
      create(:person)
      ship = create(:ship)

      post(board_url, params: {
        board: {
          ship_id: ship.id,
          ship_slug: ship.slug
        }
      })

      assert_response :redirect
    end
  end

  describe '#disembark' do
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

  describe '#travel' do
    it 'redirects on success' do
      ship = create(:ship)
      location = create(:location)

      post(travel_url, params: {
        travel: {
          ship_id: ship.id,
          ship_slug: ship.slug,
          location_id: location.id
        }
      })

      assert_response :redirect
    end
  end
end
