require 'rails_helper'

RSpec.describe Actions::FlightController do
  let(:ship) { create(:ship) }
  let(:ship_id) { ship.id }

  before do
    sign_in create(:user, person: person)
  end

  describe '#board' do
    let(:person) { create(:person) }

    before do
      post(board_url, params: {
        board: {
          ship_id: ship_id,
          ship_slug: ship.slug,
          dock_slug: ship.dock.slug
        }
      })
    end

    it 'redirects' do
      assert_redirected_to ship.dock
    end

    context 'and ship not found' do
      let(:ship_id) { nil }

      it 'renders 422' do
        assert_response :unprocessable_entity
      end
    end

    context 'and already part of crew' do
      let(:person) { create(:person, ship: ship) }

      it 'redirects' do
        assert_redirected_to ship
      end

      it 'sets errors flash' do
        expect(flash[:errors]).to_not be_empty
      end
    end
  end

  describe '#cancel_boarding_request' do
    let(:person) { create(:person) }
    let(:ship_boarding_request) { create(:ship_boarding_request, requester: person) }

    before do
      post(cancel_boarding_request_url, params: {
        ship_boarding_request: {
          id: ship_boarding_request.id,
          dock_slug: ship.dock.slug
        }
      })
    end

    it 'redirects' do
      assert_redirected_to ship.dock
    end
  end

  describe '#disembark' do
    let(:person) { create(:person, ship: ship) }

    before do
      post(disembark_url, params: {
        disembark: {
          ship_id: ship_id
        }
      })
    end

    it 'redirects' do
      assert_redirected_to person.location
    end

    it 'sets flash success' do
      expect(flash[:success]).to be_present
    end

    context 'and not in crew' do
      let(:person) { create(:person) }

      it 'redirects' do
        assert_redirected_to person.location
      end

      it 'sets errors flash' do
        expect(flash[:errors]).to_not be_empty
      end
    end

    context 'and disembarking unsuccessful' do
      let(:ship_id) { nil }

      it 'raises error' do
        subject
        assert_response :unprocessable_entity
      end
    end
  end

  describe '#refuel' do
    let(:person) { create(:person, :with_bank, ship: ship) }

    subject do
      post(refuel_url, params: {
        refuel: {
          ship_id: ship_id,
          ship_slug: ship.slug,
          refuel: 'full_tank'
        }
      })
    end

    it 'redirects' do
      subject
      assert_redirected_to ship_dock_services_url(ship)
    end
  end

  describe '#travel' do
    let(:person) { create(:person, ship: ship) }
    let(:location) { create(:location) }
    let(:location_id) { location.id }

    before do
      post(travel_url, params: {
        travel: {
          ship_id: ship_id,
          ship_slug: ship.slug,
          location_id: location_id
        }
      })
    end

    it 'redirects' do
      assert_redirected_to ship
    end

    it 'sets flash success' do
      expect(flash[:success]).to be_present
    end

    context 'and ship not found' do
      let(:ship_id) { nil }

      it 'renders 422' do
        assert_response :unprocessable_entity
      end
    end

    context 'and location not found' do
      let(:location_id) { nil }

      it 'renders 422' do
        assert_response :unprocessable_entity
      end
    end

    context 'and travelling unsuccessful' do
      let(:location_id) { ship.location.id }

      it 'redirects' do
        assert_redirected_to ship
      end

      it 'sets errors flash' do
        expect(flash[:errors]).to be_present
      end
    end
  end
end
