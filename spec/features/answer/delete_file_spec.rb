# frozen_string_literal: true

feature 'Author of answer can delete attached files', "
  In order to remove unnecessary files
  As the author of the answer
  I'd like to be able to delete attached files
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) do
    create(:answer, question: question, files: [Rack::Test::UploadedFile.new(Rails.root.join('Gemfile.lock'))])
  end

  describe 'authenticated user' do
    background { sign_in(user) }

    scenario 'deletes files attached to his answer', js: true do
      user.answers.push(answer)

      visit question_path(question)
      page.accept_confirm { click_link 'Delete file' }

      expect(page).not_to have_link 'Gemfile.lock'
    end

    scenario "tries to delete files attached to someone else's answer" do
      visit question_path(question)

      expect(page).not_to have_link 'Delete file'
    end
  end

  scenario 'unauthenticated user tries to delete attached files' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete file'
  end
end
