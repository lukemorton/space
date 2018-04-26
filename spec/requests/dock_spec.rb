require 'rails_helper'

RSpec.describe 'Dock' do
  it 'returns successfully' do
    get dock_url(create(:dock))
    assert_response :success
  end
end
