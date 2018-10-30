require 'rails_helper'

RSpec.describe Actions::RequestingToBoardController do
  let(:ship) { create(:ship) }
  let(:ship_id) { ship.id }

  before do
    sign_in create(:user, person: person)
  end

  describe '#request_to_board' do
    let(:person) { create(:person) }

    before do
      post(request_to_board_url, params: {
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

    context 'and already have request to board' do
      let(:ship) do
        create(:ship).tap do |ship|
          create(:ship_boarding_request, ship: ship, requester: person)
        end
      end

      it 'renders 422' do
        assert_response :unprocessable_entity
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
end
