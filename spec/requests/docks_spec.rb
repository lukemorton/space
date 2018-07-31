require 'rails_helper'

RSpec.describe DocksController do
  before do
    sign_in create(:user, :with_person)
  end

  describe '#show' do
    it 'returns successfully' do
      get dock_url(create(:dock))
      assert_response :success
    end
  end
end
