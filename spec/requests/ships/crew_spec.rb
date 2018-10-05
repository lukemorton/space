require 'rails_helper'

RSpec.describe Ships::CrewController do
  let(:person) { create(:person) }

  before do
    sign_in create(:user, person: person)
  end

  describe '#show' do
    it 'returns successfully' do
      get ship_crew_index_url(create(:ship, crew: [person]))
      assert_response :success
    end
  end
end
