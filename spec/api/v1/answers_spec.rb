# frozen_string_literal: true

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/answers' do
    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/answers', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/answers', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:files) do
        [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')),
         Rack::Test::UploadedFile.new(Rails.root.join('yarn.lock'))]
      end
      let!(:answers) { create_list(:answer, 2, files: files) }
      let(:answer) { answers.first }
      let(:answer_json) { json['answers'].first }
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before { get '/api/v1/answers', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_json) { answer_json['comments'].first }

        it 'returns list of comments' do
          expect(answer_json['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(comment_json[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_json) { answer_json['links'].first }

        it 'returns list of links' do
          expect(answer_json['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_json[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_json) { answer_json['files'].first }

        it 'returns list of files' do
          expect(answer_json['files'].size).to eq 2
        end

        it 'returns file url' do
          expect(file_json['url']).to eq url_for(file).delete_prefix('http://www.example.com')
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:files) do
      [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')),
       Rack::Test::UploadedFile.new(Rails.root.join('yarn.lock'))]
    end
    let(:answer) { create(:answer, files: files) }

    context 'when unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_json) { json['answer'] }
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_json) { answer_json['comments'].first }

        it 'returns list of comments' do
          expect(answer_json['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(comment_json[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_json) { answer_json['links'].first }

        it 'returns list of links' do
          expect(answer_json['links'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_json[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_json) { answer_json['files'].first }

        it 'returns list of files' do
          expect(answer_json['files'].size).to eq 2
        end

        it 'returns file url' do
          expect(file_json['url']).to eq url_for(file).delete_prefix('http://www.example.com')
        end
      end
    end
  end
end