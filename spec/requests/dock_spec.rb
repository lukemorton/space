require 'rails_helper'

RSpec.describe 'Dock' do
  it 'returns successfully' do
    create(:person)
    get dock_url(create(:dock))
    assert_response :success
  end
end
