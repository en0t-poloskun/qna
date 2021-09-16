# frozen_string_literal: true

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Showable' do
        let(:resource) { me }
        let(:resource_json) { json['user'] }
        let(:public_fields) { %w[id email admin created_at updated_at] }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'when authorized' do
      let!(:resources) { create_list(:user, 2) }
      let(:me) { create(:user) }

      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Indexable' do
        let(:resource) { resources.first }
        let(:resources_json) { json['users'] }
        let(:resource_json) { json['users'].first }
        let(:public_fields) { %w[id email admin created_at updated_at] }
      end

      it 'does not return current user' do
        json['users'].each do |profile|
          expect(profile['id']).not_to eq me.id
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['users'].first).not_to have_key(attr)
        end
      end
    end
  end
end
