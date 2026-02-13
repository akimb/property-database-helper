class Import < ApplicationRecord
  has_many :units

  STATUSES = ["pending", "completed", "cancelled"].freeze # enum for the csv statuses

  validates :status, inclusion: { in: STATUSES }
  validates :raw_csv, presence: true
end
