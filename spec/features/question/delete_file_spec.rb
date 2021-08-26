# frozen_string_literal: true

feature 'Author of question can delete attached files', "
  In order to remove unnecessary files
  As the author of the question
  I'd like to be able to delete attached files
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user' do
    background do
      sign_in(user)

      question.files.attach(Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock')))
    end

    scenario 'deletes files attached to his question' do
      user.questions.push(question)

      visit question_path(question)
      click_on 'Delete file'

      expect(page).not_to have_link 'Gemfile.lock'
    end

    scenario "tries to delete files attached to someone else's question" do
      visit question_path(question)

      expect(page).not_to have_link 'Delete file'
    end
  end

  scenario 'unauthenticated user tries to delete attached files' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete file'
  end
end
