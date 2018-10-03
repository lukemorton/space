require 'rails_helper'

RSpec.describe ShipsController do
  describe '#not_found' do
    it 'returns not found' do
      get '/404'
      assert_response :not_found
    end
  end

  describe '#unprocessable_entity' do
    it 'returns not found' do
      get '/422'
      assert_response :unprocessable_entity
    end
  end
end
