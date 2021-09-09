# frozen_string_literal: true

feature 'User can comment question', "
  In order to communicate with question's author
  As an authenticated user
  I'd like to be able to comment question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'adds a comment' do
      fill_in 'Comment', with: 'text text text'
      click_on 'Send'

      expect(page).to have_content 'text text text'
    end

    scenario 'adds a comment with errors' do
      click_on 'Send'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'unauthenticated user tries to add a comment' do
    visit question_path(question)

    expect(page).not_to have_selector '.comments_form'
  end
end
