# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @user = users(:alice)
    @report = reports(:one)
    visit new_user_session_url
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました'
  end

  test 'should create Report' do
    visit reports_url
    click_on '日報'
    click_on '日報の新規作成'
    fill_in 'report[title]', with: @report.title
    fill_in 'report[content]', with: @report.content
    click_on '登録する'
    assert_text '日報が作成されました'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集'
    fill_in 'report[title]', with: '内容'
    fill_in 'report[content]', with: '修正した。'
    click_on '更新する'
    assert_text '日報が更新されました'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first
    assert_text '日報が削除されました'
  end
end
