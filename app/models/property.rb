class Property < ApplicationRecord
  has_many :units, dependent: :destroy # important to say for having multiple units

  ## IMPORTANT FOR VALIDATING DUPLICATES
  validates :name, presence: true, uniqueness: { case_sensitive: false } # validation for naming and uniqueness without case sensitivity

end
