require 'rails_helper'

RSpec.describe ShipsController do
  let(:person) { create(:person) }

  before do
    sign_in create(:user, person: person)
  end

  describe '#show' do
    it 'returns successfully' do
      get ship_url(create(:ship, crew: [person]))
      assert_response :success
    end

    it 'redirects when person not in crew' do
      get ship_url(create(:ship, crew: []))
      assert_redirected_to person.location
    end

    it 'raises not found when ship not found' do
      get ship_url('not a ship')
      assert_response :not_found
    end
  end
end
