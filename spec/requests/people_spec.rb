require 'rails_helper'

RSpec.describe ShipsController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe '#new' do
    it 'returns successfully' do
      get new_person_path
      assert_response :success
    end

    it 'redirects if user has person' do
      create(:person, user: user)
      get new_person_path
      assert_redirected_to root_path
    end
  end

  describe '#create' do
    before do
      create(:location)
    end

    it 'redirects when successful' do
      post people_path, params: {
        person: {
          name: 'Luke'
        }
      }
      assert_redirected_to root_path
    end

    it 'renders new when unsuccessful' do
      post people_path, params: {
        person: {
          name: ''
        }
      }
      assert_response :success
    end
  end
end
