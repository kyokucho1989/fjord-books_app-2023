# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentions_as_source, class_name: 'Mention', foreign_key: 'mentioning_report_id', inverse_of: :mentioned_report, dependent: :destroy
  has_many :mentioned_reports, through: :mentions_as_source

  has_many :mentions_as_target, class_name: 'Mention', foreign_key: 'mentioned_report_id', inverse_of: :mentioning_report, dependent: :destroy
  has_many :mentioning_reports, through: :mentions_as_target

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def self.update_mention(report)
    mentioned_report_id = report.id
    mention_ids = mentioning_reports(report)
    create_mention_ids = mention_ids[:create_ids]
    delete_mention_ids = mention_ids[:delete_ids]
    create_mention_ids.each do |id|
      mention = Mention.new(mentioning_report_id: id, mentioned_report_id:)
      mention.save
    end

    mention = Mention.where(mentioning_report_id: delete_mention_ids, mentioned_report_id:)
    mention.delete_all if !mention.empty?
  end

  def self.mentioning_reports(report)
    mentioning_reports = report.content.scan(%r{localhost:3000/reports/(\d+)}).flatten
    mentioning_reports.uniq!
    mentioning_reports.map!(&:to_i)

    create_reports_ids = mentioning_reports - report.mentioning_report_ids
    delete_reports_ids = report.mentioning_report_ids - mentioning_reports
    { create_ids: create_reports_ids, delete_ids: delete_reports_ids }
  end
end
