# frozen_string_literal: true

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:files) do
        [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')),
         Rack::Test::UploadedFile.new(Rails.root.join('yarn.lock'))]
      end
      let!(:resources) { create_list(:question, 2, files: files) }
      let(:resource) { resources.first }
      let(:resources_json) { json['questions'] }
      let(:resource_json) { resources_json.first }

      let!(:comments) { create_list(:comment, 3, commentable: resource) }
      let!(:links) { create_list(:link, 3, linkable: resource) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Indexable' do
        let(:public_fields) { %w[id title body author_id created_at updated_at] }
      end

      it_behaves_like 'API Comentable'

      it_behaves_like 'API Linkable'

      it_behaves_like 'API Filable'
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:files) do
      [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')),
       Rack::Test::UploadedFile.new(Rails.root.join('yarn.lock'))]
    end
    let(:question) { create(:question, files: files) }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:resource_json) { json['question'] }
      let(:resource) { question }

      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Showable' do
        let(:public_fields) { %w[id title body author_id created_at updated_at] }
      end

      it_behaves_like 'API Comentable'

      it_behaves_like 'API Linkable'

      it_behaves_like 'API Filable'
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :post }
    end

    context 'when authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'API Creatable' do
        let(:post_create) do
          post api_path, params: { access_token: access_token.token, question: resource_params }, headers: headers
        end
        let(:resource) { :question }
        let(:association) { 'questions' }
        let(:resource_class) { Question }
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :patch }
    end

    context 'when authorized' do
      it_behaves_like 'API Updatable' do
        let(:patch_update) do
          patch api_path, params: { access_token: access_token.token, question: resource_params }, headers: headers
        end
        let(:valid_params) { { title: 'new title', body: 'new body' } }
        let(:invalid_params) { attributes_for(:question, :invalid) }
        let(:resource) { question }
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :delete }
    end

    context 'when authorized' do
      it_behaves_like 'API Deletable' do
        let(:delete_destroy) { delete api_path, params: { access_token: access_token.token }, headers: headers }
        let(:association) { 'questions' }
        let(:resource_class) { Question }
      end
    end
  end
end
