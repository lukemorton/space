require 'rails_helper'

RSpec.describe DocksController do
  let(:person) { create(:person) }

  before do
    sign_in create(:user, person: person)
  end

  describe '#show' do
    it 'returns successfully for valid dock' do
      get dock_url(create(:dock, location: person.location))
      assert_response :success
    end

    it 'redirects to current location when dock not in location' do
      get dock_url(create(:dock))
      assert_redirected_to location_path(person.location)
    end

    it 'raises not found when dock not found' do
      expect{get dock_url('not a dock')}.to raise_error(ActionController::RoutingError)
    end
  end
end
