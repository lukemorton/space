require 'rails_helper'

RSpec.describe 'Travelling' do
  it 'redirects on success' do
    person = create(:person)
    post travel_url, params: { travel: { person_id: person.id, location: 'New location' } }
    assert_response :redirect
  end
end
