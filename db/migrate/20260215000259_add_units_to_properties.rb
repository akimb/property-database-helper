class AddUnitsToProperties < ActiveRecord::Migration[8.1]
  def change
    add_column :units, :imported_property_id, :bigint
    add_foreign_key :units, :imported_properties
  end
end
