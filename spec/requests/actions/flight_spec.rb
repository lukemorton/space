require 'rails_helper'

RSpec.describe Actions::FlightController do
  let(:ship) { create(:ship) }
  let(:ship_id) { ship.id }

  describe '#board' do
    let(:person) { create(:person) }

    before do
      person

      post(board_url, params: {
        board: {
          ship_id: ship_id,
          ship_slug: ship.slug
        }
      })
    end

    it 'redirects' do
      assert_redirected_to ship
    end

    it 'sets flash notice' do
      expect(flash.notice).to be_present
    end

    context 'and boarding unsuccessful' do
      let(:ship_id) { 0 }

      it 'redirects' do
        assert_redirected_to person.location
      end

      it 'sets flash alert' do
        expect(flash.alert).to be_present
      end
    end
  end

  describe '#disembark' do
    let(:person) { create(:person, ship: ship) }

    before do
      person

      post(disembark_url, params: {
        disembark: {
          ship_id: ship_id,
          ship_slug: ship.slug
        }
      })
    end

    it 'redirects' do
      assert_redirected_to person.location
    end

    it 'sets flash notice' do
      expect(flash.notice).to be_present
    end

    context 'and disembarking unsuccessful' do
      let(:ship_id) { nil }

      it 'redirects' do
        assert_redirected_to ship
      end

      it 'sets flash alert' do
        expect(flash.alert).to be_present
      end
    end
  end

  describe '#travel' do
    it 'redirects on success' do
      location = create(:location)

      post(travel_url, params: {
        travel: {
          ship_id: ship_id,
          ship_slug: ship.slug,
          location_id: location.id
        }
      })

      assert_response :redirect
    end
  end
end
