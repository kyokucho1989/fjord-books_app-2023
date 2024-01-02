# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable' do
    user1 = users(:alice)
    user2 = users(:bob)
    user1.reports.create!(title: 'title', content: 'hello')
    assert user1.reports.first.editable?(user1)
    assert_not user1.reports.first.editable?(user2)
  end

  test '#create_on' do
    user1 = users(:alice)
    user1.reports.create!(title: 'title', content: 'hello')
    report1 = user1.reports.first
    assert_equal(report1.created_on, report1.created_at.to_date)
  end

  test '#save_mention' do
    user1 = users(:alice)
    user2 = users(:bob)
    report1 = user1.reports.create!(title: '朝', content: 'good morning')
    report2 = user2.reports.create!(title: '言及', content: "http://localhost:3000/reports/#{report1.id}")
    report3 = user2.reports.create!(title: '言及2', content: "http://localhost:3000/reports/#{report1.id}")

    assert_includes(report1.mentioned_reports, report2)
    assert_includes(report1.mentioned_reports, report3)
    assert_not_includes(report2.mentioned_reports, report1)

    update_content = 'good bye'
    report2.update(title: '言及の修正', content: update_content)
    report4 = user2.reports.create!(title: '言及の追加', content: "http://localhost:3000/reports/#{report1.id}")

    assert_includes(report1.mentioned_reports, report3)
    assert_not_includes(report1.mentioned_reports, report2)
    assert_includes(report1.mentioned_reports, report4)
  end
end
