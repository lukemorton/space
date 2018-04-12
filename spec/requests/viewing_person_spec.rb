require 'rails_helper'

RSpec.describe 'Viewing person' do
  it 'has 200 code' do
    get person_url(create(:person))
    assert_response :success
  end
end
