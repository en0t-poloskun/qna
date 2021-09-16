# frozen_string_literal: true

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let!(:profiles) { create_list(:user, 3) }
      let(:me) { profiles.last }
      let(:profile) { profiles.first }
      let(:profile_json) { json['users'].first }

      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of profiles' do
        expect(json['users'].size).to eq 2
      end

      it 'does not return current user' do
        json['users'].each do |profile|
          expect(profile['id']).not_to eq me.id
        end
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(profile_json[attr]).to eq profile.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(profile_json).not_to have_key(attr)
        end
      end
    end
  end
end
