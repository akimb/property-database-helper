class ImportedProperty < ApplicationRecord
  # this is the temporary property before it gets saved as the final property shown in property.rb
  belongs_to :import
  has_many :units, dependent: :destroy

  validates :name, presence: true
end
