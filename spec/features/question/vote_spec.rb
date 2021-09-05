# frozen_string_literal: true

feature 'User can vote for question', "
  In order to give a rating for question
  As an authenticated user
  I'd like to be able to vote for question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'votes for question' do
      click_on 'Vote for'

      expect(page).to have_content 'Rating: 1'
    end

    scenario 'votes against question' do
      click_on 'Vote against'

      expect(page).to have_content 'Rating: -1'
    end
  end

  scenario 'unauthenticated user tries to vote for question' do
    visit question_path(question)

    expect(page).not_to have_link 'Vote for'
    expect(page).not_to have_link 'Vote against'
  end
end
