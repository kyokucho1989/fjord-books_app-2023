class Report < ApplicationRecord
  has_many :comments, as: :post
end
