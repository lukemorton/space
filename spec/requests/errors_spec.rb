require 'rails_helper'

RSpec.describe ErrorsController do
  describe '#internal_server_error' do
    it 'returns internal server error' do
      get '/500'
      assert_response :internal_server_error
    end
  end

  describe '#not_found' do
    it 'returns not found' do
      get '/404'
      assert_response :not_found
    end

    it 'returns not found if requested by xhr' do
      get '/404', xhr: true
      assert_response :not_found
    end

    it 'returns javascript if request by xhr' do
      get '/404', xhr: true
      expect(response.content_type).to include('text/javascript')
    end
  end

  describe '#unprocessable_entity' do
    it 'returns unprocessable entity' do
      get '/422'
      assert_response :unprocessable_entity
    end

    it 'returns unprocessable entity if requested by xhr' do
      get '/422', xhr: true
      assert_response :unprocessable_entity
    end

    it 'returns javascript if request by xhr' do
      get '/422', xhr: true
      expect(response.content_type).to include('text/javascript')
    end
  end
end
