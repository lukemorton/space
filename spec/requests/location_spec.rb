require 'rails_helper'

RSpec.describe 'Travelling' do
  it 'redirects on success' do
    get location_url(create(:location))
    assert_response :success
  end
end
