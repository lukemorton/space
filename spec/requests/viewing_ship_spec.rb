require 'rails_helper'

RSpec.describe 'Viewing ship' do
  it 'returned successfully' do
    get ship_url(create(:person))
    assert_response :success
  end
end
