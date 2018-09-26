require 'rails_helper'

RSpec.describe HelpController do
  before do
    sign_in create(:user, :with_person)
  end

  describe '#index' do
    it 'returns successfully' do
      get help_index_url
      assert_response :success
    end
  end
end
