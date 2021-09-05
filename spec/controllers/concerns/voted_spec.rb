# frozen_string_literal: true

shared_examples_for 'voted' do
  let(:user) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:rating_json) do
    { votable_class: votable.class.to_s.downcase, votable_id: votable.id, value: votable.rating }.to_json
  end

  describe 'POST #vote_for' do
    before { login(user) }

    let(:post_vote_for) { post :vote_for, params: { id: votable }, format: :json }

    context 'when user has not voted' do
      it 'saves a new vote in the database' do
        expect { post_vote_for }.to change(votable.votes, :count).by(1)
      end

      it 'increases the rating' do
        expect { post_vote_for }.to change(votable, :rating).by(1)
      end

      it 'renders rating json' do
        post_vote_for
        expect(response.body).to eq rating_json
      end
    end

    context 'when user is an author' do
      let(:votable) { create(model.to_s.underscore.to_sym, author: user) }

      it 'does not save a new vote in the database' do
        expect { post_vote_for }.to change(votable.votes, :count).by(0)
      end

      it 'returns status: No Content' do
        post_vote_for

        expect(response.status).to eq 204
      end
    end

    context 'when user has already voted' do
      before { create(:vote, votable: votable, voter: user) }

      it 'does not save a new vote in the database' do
        expect { post_vote_for }.to change(votable.votes, :count).by(0)
      end

      it 'returns status: No Content' do
        post_vote_for

        expect(response.status).to eq 204
      end
    end
  end

  describe 'POST #vote_against' do
    before { login(user) }

    let(:post_vote_against) { post :vote_against, params: { id: votable }, format: :json }

    context 'when user has not voted' do
      it 'saves a new vote in the database' do
        expect { post_vote_against }.to change(votable.votes, :count).by(1)
      end

      it 'decreases the rating' do
        expect { post_vote_against }.to change(votable, :rating).by(-1)
      end

      it 'renders rating json' do
        post_vote_against

        expect(response.body).to eq rating_json
      end
    end
  end

  describe 'DELETE #destroy_vote' do
    before { login(user) }

    context 'when user is a voter' do
      before { create(:vote, votable: votable, voter: user) }

      let(:delete_destroy_vote) { delete :destroy_vote, params: { id: votable }, format: :json }

      it 'deletes the vote' do
        expect { delete_destroy_vote }.to change(votable.votes, :count).by(-1)
      end

      it 'renders rating json' do
        delete_destroy_vote

        expect(response.body).to eq rating_json
      end
    end

    context 'when user is not a voter' do
      let(:delete_destroy_vote) { delete :destroy_vote, params: { id: votable }, format: :json }

      it 'does not delete the vote' do
        expect { delete_destroy_vote }.not_to change(Vote, :count)
      end

      it 'renders rating json' do
        delete_destroy_vote

        expect(response.body).to eq rating_json
      end
    end
  end
end
