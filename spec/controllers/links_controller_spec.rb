# frozen_string_literal: true

describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'when user is an author of resource' do
      let!(:question) { create(:question, author: user) }
      let!(:link) { create(:link, linkable: question) }

      let(:delete_request) { delete :destroy, params: { id: link }, format: :js }

      it 'deletes link' do
        expect { delete_request }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy template' do
        delete_request

        expect(response).to render_template :destroy
      end
    end

    context 'when user is not an author of resource' do
      let!(:question) { create(:question) }
      let!(:link) { create(:link, linkable: question) }

      let(:delete_request) { delete :destroy, params: { id: link }, format: :js }

      it 'does not delete link' do
        expect { delete_request }.not_to change(Link, :count)
      end

      it 'redirects to root' do
        delete_request

        expect(response).to redirect_to root_path
      end
    end
  end
end
