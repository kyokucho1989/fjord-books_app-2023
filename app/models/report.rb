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

  def save_with_mentions(report_params = nil)
    has_no_validation_error = true
    has_no_mention_error = true
    mention_errors = ActiveModel::Errors.new(self)
    ActiveRecord::Base.transaction do
      has_no_validation_error &= if report_params
                                   update(report_params)
                                 else
                                   save
                                 end
      raise ActiveRecord::Rollback if !has_no_validation_error

      has_no_mention_error, mention_errors = update_mentions
      has_no_validation_error &= has_no_mention_error
    end
    [has_no_validation_error, mention_errors]
  end

  def update_mentions
    has_no_mention_error = true
    mentioned_report_id = id
    mention_errors = ActiveModel::Errors.new(self)
    mention_ids = mentioning_reports
    create_mention_ids = mention_ids[:create_ids]
    delete_mention_ids = mention_ids[:delete_ids]
    create_mention_ids.each do |id|
      mention = Mention.new(mentioning_report_id: id, mentioned_report_id:)
      has_no_mention_error &= mention.save
      mention_errors.merge!(mention.errors) if mention.errors.any?
    end
    mention = Mention.where(mentioning_report_id: delete_mention_ids, mentioned_report_id:)
    mention.delete_all if mention.exists?
    [has_no_mention_error, mention_errors]
  end

  def mentioning_reports
    mentioning_reports = content.scan(%r{localhost:3000/reports/(\d+)}).flatten
    mentioning_reports.uniq!
    mentioning_reports.map!(&:to_i)
    create_reports_ids = mentioning_reports - mentioning_report_ids
    delete_reports_ids = mentioning_report_ids - mentioning_reports
    { create_ids: create_reports_ids, delete_ids: delete_reports_ids }
  end
end
