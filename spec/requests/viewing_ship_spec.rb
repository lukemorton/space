require 'rails_helper'

RSpec.describe 'Viewing ship' do
  it 'returned successfully' do
    get ship_url(create(:ship, crew: [create(:person)]))
    assert_response :success
  end

  it 'redirect when not in crew' do
    create(:person)
    get ship_url(create(:ship, crew: []))
    assert_response :redirect
  end
end
