class ImportedProperty < ApplicationRecord
  belongs_to :import

  validates :name, presence: true

  # store units as JSON array
  # allows us to query/update units easily while keeping structure simple
  # mysql JSON columns can't have defaults, so we initialize in the model
  # Initialize `units` to an empty array in Ruby to avoid relying on DB defaults
  attribute :units, default: -> { [] }

  # make sure all units are [] to avoid infinite recursion
  before_save :ensure_units_array

  private

  def ensure_units_array
    self.units = [] if units.nil?
  end
end
