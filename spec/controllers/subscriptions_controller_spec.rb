# frozen_string_literal: true

describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    let(:post_create) { post :create, params: { question_id: question }, format: :js }

    context 'when user not subscribed' do
      let!(:question) { create(:question) }

      it 'saves a new subscription in the database' do
        expect { post_create }.to change(Subscription, :count).by(1)
      end

      it 'adds subscribed question to user' do
        expect { post_create }.to change(user.subscribed_questions, :count).by(1)
      end

      it 'adds subscriber to question' do
        expect { post_create }.to change(question.subscribers, :count).by(1)
      end

      it 'renders subscription create template' do
        post_create

        expect(response).to render_template :create
      end
    end

    context 'when user subscribed' do
      let!(:question) { create(:question, author: user) }

      it 'does not save subscription' do
        expect { post_create }.not_to change(Subscription, :count)
      end

      it 'redirects to root' do
        post_create

        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'when user subscribed' do
      let!(:subscription) { create(:subscription, user: user) }
      let(:delete_request) { delete :destroy, params: { id: subscription }, format: :js }

      it 'deletes subscription' do
        expect { delete_request }.to change(Subscription, :count).by(-1)
      end

      it 'renders destroy template' do
        delete_request

        expect(response).to render_template :destroy
      end
    end

    context 'when user not subscribed' do
      let!(:subscription) { create(:subscription) }
      let(:delete_request) { delete :destroy, params: { id: subscription }, format: :js }

      it 'does not delete subscription' do
        expect { delete_request }.not_to change(Subscription, :count)
      end

      it 'riderects to root' do
        delete_request

        expect(response).to redirect_to root_path
      end
    end
  end
end