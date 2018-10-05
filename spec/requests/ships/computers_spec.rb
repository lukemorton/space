require 'rails_helper'

RSpec.describe Ships::ComputersController do
  let(:person) { create(:person) }

  before do
    sign_in create(:user, person: person)
  end

  describe '#index' do
    it 'returns successfully' do
      get ship_computers_url(create(:ship, crew: [person]))
      assert_response :success
    end
  end
end
