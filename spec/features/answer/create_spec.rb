# frozen_string_literal: true

feature 'User can create answer', "
  In order to help the author of the question
  As an authenticated user
  I'd like to be able to add an answer to the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'adds an answer' do
      fill_in 'Body', with: 'text text text'
      click_on 'Add'

      expect(page).to have_current_path question_path(question), ignore_query: true

      within '.answers' do
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'adds an answer with errors' do
      click_on 'Add'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'adds an answer with attached files' do
      fill_in 'Body', with: 'text text text'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add'

      expect(page).to have_current_path question_path(question), ignore_query: true

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'unauthenticated user tries to add an answer' do
    visit question_path(question)
    click_on 'Add'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
