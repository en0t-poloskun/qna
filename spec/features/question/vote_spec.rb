# frozen_string_literal: true

feature 'User can vote for question', "
  In order to give a rating for question
  As an authenticated user
  I'd like to be able to vote for question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background { sign_in(user) }

    scenario 'votes for question' do
      visit question_path(question)

      click_on 'Vote for'

      expect(page).to have_content 'Rating: 1'
    end

    scenario 'votes against question' do
      visit question_path(question)

      click_on 'Vote against'

      expect(page).to have_content 'Rating: -1'
    end

    scenario 'tries to vote for his question' do
      user.questions.push(question)

      visit question_path(question)

      expect(page).not_to have_link 'Vote for'
      expect(page).not_to have_link 'Vote against'
    end

    scenario 'tries to vote one more time' do
      create(:vote, votable: question, voter: user)

      visit question_path(question)

      expect(page).not_to have_link 'Vote for'
      expect(page).not_to have_link 'Vote against'
    end

    scenario 're-votes' do
      create(:vote, votable: question, voter: user)

      visit question_path(question)

      click_on 'Re-vote'

      expect(page).to have_content 'Rating: 0'
      expect(page).to have_link 'Vote for'
      expect(page).to have_link 'Vote against'
    end
  end

  scenario 'unauthenticated user tries to vote for question', js: true do
    visit question_path(question)

    expect(page).not_to have_link 'Vote for'
    expect(page).not_to have_link 'Vote against'
  end
end
