# REFACTORED: New migration to create imported_properties table
# This new table stores parsed CSV data as individual records
# instead of keeping everything in raw_csv column
# Schema design:
# - import_id: foreign key to imports
# - name, street_address, city, state, zip_code: property details from CSV
# - units: JSON array of unit numbers
# - zip_valid: cached validation result from CsvParserService logic
class CreateImportedProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :imported_properties do |t|
      t.bigint :import_id, null: false
      
      t.string :name, null: false
      
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.json :units
      t.boolean :zip_valid, default: false
      
      t.timestamps
      t.index [:import_id]
      t.foreign_key :imports
    end
  end
end
