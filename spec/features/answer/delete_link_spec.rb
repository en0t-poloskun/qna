# frozen_string_literal: true

feature 'Author of answer can delete attached links', "
  In order to remove unnecessary links
  As the author of the answer
  I'd like to be able to delete attached links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'authenticated user' do
    background { sign_in(user) }

    scenario 'deletes link attached to his answer', js: true do
      user.answers.push(answer)

      visit question_path(question)
      page.accept_confirm { click_link 'Delete link' }

      expect(page).not_to have_link link.name, href: link.url
    end

    scenario "tries to delete link attached to someone else's answer" do
      visit question_path(question)

      expect(page).not_to have_link 'Delete link'
    end
  end

  scenario 'unauthenticated user tries to delete links' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end
end
