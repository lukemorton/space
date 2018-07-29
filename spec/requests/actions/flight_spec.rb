require 'rails_helper'

RSpec.describe Actions::FlightController do
  describe '#board' do
    let(:person) { create(:person) }
    let(:ship) { create(:ship) }

    before do
      person

      post(board_url, params: {
        board: {
          ship_id: ship.id,
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
      let(:ship) { double(id: 0, slug: '') }

      it 'redirects' do
        assert_redirected_to person.location
      end

      it 'sets flash alert' do
        expect(flash.alert).to be_present
      end
    end
  end

  describe '#disembark' do
    let(:person) { create(:person) }

    before do
      person
      ship = create(:ship)

      post(disembark_url, params: {
        disembark: {
          ship_id: ship.id
        }
      })
    end

    it 'redirects on success' do
      assert_redirected_to person.location
    end

    it 'sets flash notice' do
      expect(flash.notice).to be_present
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
