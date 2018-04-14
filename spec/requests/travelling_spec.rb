require 'rails_helper'

RSpec.describe 'Travelling' do
  it 'redirects on success' do
    person = create(:person)
    location = create(:location)

    post(travel_url, params: {
      travel: {
        person_id: person.id,
        location_id: location.id
      }
    })

    assert_response :redirect
  end
end
