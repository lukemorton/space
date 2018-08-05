require 'rails_helper'

RSpec.describe DocksController do
  before do
    sign_in create(:user, :with_person)
  end

  describe '#show' do
    it 'returns successfully for valid dock' do
      get dock_url(create(:dock))
      assert_response :success
    end

    it 'raises not found when dock not found' do
      expect{get dock_url('not a dock')}.to raise_error(ActionController::RoutingError)
    end
  end
end
