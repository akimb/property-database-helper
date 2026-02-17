class Unit < ApplicationRecord
  belongs_to :property, optional: true

  belongs_to :imported_property, optional: true
  # belongs_to :import, optional: true

  validates :unit_number, presence: true # makes it so units cannot be left blank if the record exists

  # prevents duplicate units
  validates :unit_number, uniqueness: { 
    scope: [:property_id, 
    :imported_property_id], 
    message: "must be unique per property."
  } 
end
