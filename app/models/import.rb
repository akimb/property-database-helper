class Import < ApplicationRecord
  
  has_many :imported_properties, dependent: :destroy
  has_many :units, dependent: :destroy

  STATUSES = ["pending", "completed", "cancelled"].freeze # enum for the csv statuses

  validates :status, inclusion: { in: STATUSES }
end
