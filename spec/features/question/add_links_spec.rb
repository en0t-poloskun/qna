# frozen_string_literal: true

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:google_url) { 'https://www.google.com/' }
  given(:yandex_url) { 'https://yandex.ru/' }
  given(:gist_url) { 'https://gist.github.com/en0t-poloskun/f0dbcb1ccd8ba61448c5c17a08c5f90b' }

  background { sign_in(user) }

  describe 'When asks question' do
    background do
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'user adds links', js: true do
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: yandex_url
      end

      click_on 'Ask'

      expect(page).to have_link 'Google', href: google_url
      expect(page).to have_link 'Yandex', href: yandex_url
    end

    scenario 'user adds a link with errors' do
      fill_in 'Url', with: 'badurl'

      click_on 'Ask'

      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'user adds a link with gist' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_content 'Hello world!'
    end
  end

  describe 'When edits question' do
    given!(:question) { create(:question, author: user) }
    given!(:old_link) { create(:link, linkable: question) }

    scenario 'user adds new link', js: true do
      visit questions_path

      click_on 'Edit'

      within '.questions' do
        click_on 'add link'

        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: yandex_url

        click_on 'Save'

        expect(page).to have_link old_link.name, href: old_link.url
        expect(page).to have_link 'Yandex', href: yandex_url
      end
    end
  end
end
