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

  describe 'mulitple sessions' do
    scenario "comment for question appears on another user's page with question", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Comment', with: 'text text text'
        click_on 'Send'

        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end
end
