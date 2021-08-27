# frozen_string_literal: true

require 'rails_helper'

describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'when user is an author of resource' do
      let!(:question) { create(:question, author: user, files: [file]) }

      let(:delete_request) { delete :destroy, params: { id: question.files.last }, format: :js }

      it 'deletes attached file' do
        expect { delete_request }.to change(question.files, :count).by(-1)
      end

      it 'renders destroy template' do
        delete_request

        expect(response).to render_template :destroy
      end
    end

    context 'when user is not an author of resource' do
      let!(:question) { create(:question, files: [file]) }

      let(:delete_request) { delete :destroy, params: { id: question.files.last }, format: :js }

      it 'does not delete attached file' do
        expect { delete_request }.not_to change(ActiveStorage::Attachment, :count)
      end

      it 'renders destroy template' do
        delete_request

        expect(response).to render_template :destroy
      end
    end
  end
end
