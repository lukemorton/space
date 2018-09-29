require 'rails_helper'

RSpec.describe DocksController do
  let(:person) { create(:person) }
  let(:user) { create(:user, person: person) }

  before do
    sign_in user
  end

  describe '#show' do
    it 'returns successfully for valid dock' do
      get dock_url(create(:dock, location: person.location))
      assert_response :success
    end

    it 'redirects to current location when dock not in location' do
      get dock_url(create(:dock))
      assert_redirected_to person.location
    end

    it 'raises not found when dock not found' do
      expect{get dock_url('not a dock')}.to raise_error(ActionController::RoutingError)
    end

    it 'redirects when person is aboard ship' do
      location = create(:location)
      person = create(:person, :with_ship, location: create(:location), user: user)
      get dock_url(person.ship.dock)
      assert_redirected_to person.ship
    end
  end
end
