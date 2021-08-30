# frozen_string_literal: true

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:google_url) { 'https://www.google.com/' }
  given(:yandex_url) { 'https://yandex.ru/' }

  scenario 'User adds links when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url
    end

    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: yandex_url
    end

    click_on 'Add'

    within '.answers' do
      expect(page).to have_link 'Google', href: google_url
      expect(page).to have_link 'Yandex', href: yandex_url
    end
  end
end
