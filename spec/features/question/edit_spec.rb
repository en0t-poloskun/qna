# frozen_string_literal: true

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background { sign_in(user) }

    scenario 'edits his question' do
      user.questions.push(question)

      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).not_to have_content question.title
        expect(page).not_to have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      user.questions.push(question)

      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'adds files to his question' do
      user.questions.push(question)

      visit questions_path

      click_on 'Edit'

      within '.questions' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).not_to have_selector 'filefield'
      end
    end

    scenario "tries to edit other user's question" do
      visit questions_path

      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'unauthenticated user tries to edit answer' do
    visit questions_path

    expect(page).not_to have_link 'Edit'
  end
end
