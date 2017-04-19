require 'rails_helper'

RSpec.describe SignupsController, type: :controller do
  before do
    load_files
    PR::Common.configure do |config|
      config.signup_params = [:email, :name, :password]
    end
  end

  let(:user) { instance_double(User, email: 'barry@example.com', confirmed?: true) } 

  describe 'POST #create' do
    context 'non-existing user' do
      let(:expected_json) { {
        'meta' => {
          'signup_success' => true,
          'existing_account' => false
        },
        'session' => {
          'email'=> 'barry@example.com',
          'user_id' => be_kind_of(Numeric),
          'access_token' => a_string_matching(/.+/),
        }
      }}

      it 'should return the correct response' do
        post :create, { signup: { email: 'barry@example.com', name: 'barry' }}

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to match(expected_json)
      end
    end

    context 'existing user with wrong password' do
      let(:expected_json) { {
        "meta" => {
          "signup_success" => false,
          "require_password" => true,
          "password_invalid" => true
        },
        "session" => nil
      }}

      it 'should return the correct response' do
        allow(User).to receive(:find_by).and_return(user)
        allow(user).to receive(:valid_password?).with('barryspassword').and_return(false)

        post :create, signup: { email: 'Barry@example.com', name: 'Barry White', password: 'barryspassword' }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to match(expected_json)
      end
    end

    context 'existing user with correct password' do
      let(:user) { FactoryGirl.create(:user, email: 'barry@example.com', password: '123456') }

      let(:expected_json) { {
        "meta" => {
          "signup_success" => true,
          "existing_account" => true
        },
        "session" => {
          "email" => "barry@example.com",
          "user_id" => be_kind_of(Numeric),
          "access_token" => a_string_matching(/.+/),
        }
      }}

      it 'should return the correct response' do
        allow(User).to receive(:find_by).and_return(user)
        allow(user).to receive(:valid_password?).with('barryspassword').and_return(true)

        post :create, signup: { email: 'Barry@example.com', name: 'Barry White', password: 'barryspassword' }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to match(expected_json)
      end
    end
  end
end
