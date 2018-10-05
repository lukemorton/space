require 'rails_helper'

RSpec.describe ShipsController do
  let(:person) { create(:person) }

  before do
    sign_in create(:user, person: person)
  end

  describe '#show' do
    it 'redirects to flight deck' do
      ship = create(:ship, crew: [person])
      get ship_path(ship)
      assert_redirected_to ship_flight_deck_path(ship)
    end
  end
end
