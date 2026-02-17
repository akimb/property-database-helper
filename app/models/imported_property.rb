class ImportedProperty < ApplicationRecord
  # this is the temporary property before it gets saved as the final property shown in property.rb
  belongs_to :import
  has_many :units, dependent: :destroy # deletes units if the import property is deleted

  validates :name, presence: true, uniqueness: { 
    scope: :import_id, 
    case_sensitive: false,
    message: " already exists. Properties must be unique."
   }
  
   validates :street_address, presence: true
   validates :city, presence: true
   validates :state, presence: true
   validates :zip_code, presence: true, numericality: true

end
