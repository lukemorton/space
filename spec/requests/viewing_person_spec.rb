require 'rails_helper'

RSpec.describe 'Viewing person' do
  it 'returned successfully' do
    get person_url(create(:person))
    assert_response :success
  end
end
