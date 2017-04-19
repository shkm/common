require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before { load_files }

  describe 'POST #create' do
    let(:expected_json) { {
      'meta' => { },
      'session' => {
        'user_id' => be_kind_of(Numeric),
        'access_token' => a_string_matching(/.+/),
        'email' => 'barry@example.com'
      }
    }}

    before do
      FactoryGirl.create(:user, email: 'barry@example.com', password: 'password')
    end

    context 'valid credentials' do
      it 'should return the correct response' do
        post :create, { signin: { email: 'barry@example.com', password: 'password' }}

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to match(expected_json)
      end
    end

    context 'invalid credentials' do
      let(:expected_json) { {
        'meta' => {
          'errors' => { 'email' => ['Invalid email and/or password'] }
        },
        'session' => nil
      }}

      context 'non-existent user' do
        it 'should return the correct response' do
          post :create, { signin: { email: 'john@example.com', password: 'password' }}

          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)).to match(expected_json)
        end
      end

      context 'wrong password' do
        it 'should return the correct response' do
          post :create, { signin: { email: 'barry@example.com', password: 'wrongpassword' }}

          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)).to match(expected_json)
        end
      end
    end
  end
end
