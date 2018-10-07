require 'rails_helper'

RSpec.describe Ships::DockServicesController do
  let(:person) { create(:person) }

  before do
    sign_in create(:user, person: person)
  end

  describe '#show' do
    it 'returns successfully' do
      get ship_dock_services_url(create(:ship, crew: [person]))
      assert_response :success
    end
  end
end
