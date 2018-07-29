require 'rails_helper'

RSpec.describe DocksController do
  before do
    sign_in create(:user)
  end

  describe '#show' do
    it 'returns successfully' do
      create(:person)
      get dock_url(create(:dock))
      assert_response :success
    end
  end
end
