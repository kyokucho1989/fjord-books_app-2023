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
    report1 = user1.reports.create!(title: '言及', content: 'hello')
    content = "http://localhost:3000/reports/#{report1.id}"
    report2 = user2.reports.create!(title: '言及', content:)
    assert_includes(report2.mentioning_reports, report1)
    assert_not_includes(report1.mentioning_reports, report2)
  end
end
