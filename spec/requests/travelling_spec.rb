require 'rails_helper'

RSpec.describe 'Travelling' do
  it 'has 200 code' do
    person = create(:person)
    post travel_url, params: { travel: { person_id: person.id, location: 'New location' } }
    assert_response :success
  end
end
