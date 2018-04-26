require 'rails_helper'

RSpec.describe 'Ship' do
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
