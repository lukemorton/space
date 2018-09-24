require 'rails_helper'

RSpec.describe LocationsController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe '#show' do
    it 'renders on success' do
      location = create(:location)
      create(:person, location: location, user: user)
      get location_url(location)
      assert_response :success
    end

    it 'redirects when person isnt currently at location' do
      location = create(:location)
      create(:person, location: create(:location), user: user)
      get location_url(location)
      assert_response :redirect
    end

    it 'raises not found when location not found' do
      create(:person, location: create(:location), user: user)
      expect{get location_url('not a location')}.to raise_error(ActionController::RoutingError)
    end

    it 'redirects when person is aboard ship' do
      location = create(:location)
      person = create(:person, :with_ship, location: create(:location), user: user)
      get location_url(location)
      assert_redirected_to ship_path(person.ship)
    end
  end
end
