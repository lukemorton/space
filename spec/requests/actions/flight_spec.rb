require 'rails_helper'

RSpec.describe Actions::FlightController do
  let(:person) { create(:person) }
  let(:ship) { create(:ship) }
  let(:ship_id) { ship.id }

  before do
    sign_in create(:user, person: person)
  end

  describe '#board' do
    subject do
      post(board_url, params: {
        board: {
          ship_id: ship_id,
          ship_slug: ship.slug
        }
      })
    end

    it 'redirects' do
      subject
      assert_redirected_to ship
    end

    it 'sets flash success' do
      subject
      expect(flash[:success]).to be_present
    end

    context 'and boarding unsuccessful' do
      let(:ship_id) { 0 }

      it 'raises error' do
        expect{subject}.to raise_error(Space::Flight::CannotBoardError)
      end
    end
  end

  describe '#disembark' do
    let(:person) { create(:person, ship: ship) }

    subject do
      post(disembark_url, params: {
        disembark: {
          ship_id: ship_id
        }
      })
    end

    it 'redirects' do
      subject
      assert_redirected_to person.location
    end

    it 'sets flash success' do
      subject
      expect(flash[:success]).to be_present
    end

    context 'and disembarking unsuccessful' do
      let(:ship_id) { nil }

      it 'raises error' do
        expect{subject}.to raise_error(Space::Flight::CannotDisembarkError)
      end
    end
  end

  describe '#refuel' do
    let(:person) { create(:person, ship: ship) }

    subject do
      post(refuel_url, params: {
        refuel: {
          ship_id: ship_id,
          ship_slug: ship.slug
        }
      })
    end

    it 'redirects' do
      subject
      assert_redirected_to ship_dock_services_url(ship)
    end
  end

  describe '#travel' do
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

    context 'and travelling unsuccessful' do
      let(:location_id) { ship.location.id }

      it 'renders 422' do
        assert_response :unprocessable_entity
      end
    end
  end
end
