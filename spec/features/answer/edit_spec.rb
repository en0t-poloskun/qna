# frozen_string_literal: true

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'edits his answer' do
      user.answers.push(answer)

      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea#answer_body'
      end
    end

    scenario 'edits his answer with errors' do
      user.answers.push(answer)

      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'adds files to his answer' do
      user.answers.push(answer)
      answer.files.attach(Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')))

      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'Gemfile.lock'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).not_to have_selector 'filefield'
      end
    end

    scenario "tries to edit other user's answer" do
      visit question_path(question)

      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end
