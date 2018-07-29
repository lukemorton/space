require 'rails_helper'

RSpec.describe ShipsController do
  before do
    sign_in create(:user)
  end

  describe '#show' do
    it 'returns successfully' do
      get ship_url(create(:ship, crew: [create(:person)]))
      assert_response :success
    end

    it 'redirects when person not in crew' do
      create(:person)
      get ship_url(create(:ship, crew: []))
      assert_response :redirect
    end
  end
end
