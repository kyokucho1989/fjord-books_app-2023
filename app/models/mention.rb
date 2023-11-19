class Mention < ApplicationRecord
  belongs_to :mentioning_report, class_name: 'Report', foreign_key: 'mentioning_report_id'
  belongs_to :mentioned_report, class_name: 'Report', foreign_key: 'mentioned_report_id'
  validates :mentioning_report_id, presence: true
  validates :mentioned_report_id, presence: true
  validates_uniqueness_of :mentioning_report_id, scope: :mentioned_report_id
end
