require 'rails_helper'

RSpec.describe LocationsController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe '#show' do
    it 'renders on success' do
      location = create(:location)
      create(:person, location: location, ship: create(:ship, location: location), user: user)
      get location_url(location)
      assert_response :success
    end

    it 'redirects when person isnt currently at location' do
      location = create(:location)
      create(:person, location: create(:location), user: user)
      get location_url(location)
      assert_response :redirect
    end
  end
end
