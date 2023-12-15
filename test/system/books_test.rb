# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @user = users(:alice)
    @book = books(:one)
    visit new_user_session_url
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: 'password'
    click_on 'ログイン'

    assert_text 'ログインしました'
  end

  test 'should create book' do
    visit books_url
    click_on '本の新規作成'

    fill_in 'book[title]', with: @book.title
    fill_in 'book[memo]', with: @book.memo
    fill_in 'book[author]', with: @book.author
    click_on '登録する'

    assert_text '本が作成されました'
  end

  test 'should update Book' do
    visit book_url(@book)
    click_on 'この本を編集'

    fill_in 'book[title]', with: '新しいタイトル'
    fill_in 'book[memo]', with: '新しい内容'
    fill_in 'book[author]', with: '新しい著者'
    click_on '更新する'

    assert_text '本が更新されました'
  end

  test 'should destroy Book' do
    visit book_url(@book)
    click_on 'この本を削除', match: :first

    assert_text '本が削除されました'
  end
end
