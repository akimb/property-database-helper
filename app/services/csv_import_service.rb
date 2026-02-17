require "csv"

class CsvImportService
  include TextCleaner

  def initialize(raw_csv, import)
    # ---------------------------------------------------------------------------------
    # Initializes the raw CSV file and creates a new Import record
    # Creates ImportedProperty records immediately.
    # ---------------------------------------------------------------------------------
    @raw_csv = raw_csv
    @import = import
  end

  def call
    # ---------------------------------------------------------------------------------
    # Extracts each row in the imported CSV file and creates a new data entry.
    # ---------------------------------------------------------------------------------

    rows = CSV.parse(@raw_csv, headers: true)
    properties = {}
    

    rows.each do |row|
      property_name = clean_information(row["Building Name"], true)
      unit_number = row["Unit"]
      street_address = clean_information(row["Street Address"], true)
      city = clean_information(row["City"], true)
      state = clean_information(row["State"], true)
      zip_code = row["Zip Code"]

      properties[property_name] ||= {
        name: property_name,
        units: [],
        street_address: street_address,
        city: city,
        state: state,
        zip_code: zip_code,
        zip_valid: self.class.valid_zip?(zip_code, state)
      }

      properties[property_name][:units] << unit_number unless unit_number.nil? || unit_number.empty?
    end

    # create ImportedProperty records in database instead of returning hash
    # This means we can query properties from now on without re-parsing CSV
    properties.values.each do |prop_data|
      imported_property = @import.imported_properties.create!(
        name: prop_data[:name],
        street_address: prop_data[:street_address],
        city: prop_data[:city],
        state: prop_data[:state],
        zip_code: prop_data[:zip_code],
        zip_valid: prop_data[:zip_valid]
      )
      
      # Create Unit records for each unit
      prop_data[:units].each do |unit_number|
        imported_property.units.create!(
          unit_number: unit_number
        )
      end
    end
  end

  private

  def self.valid_zip?(zip_prefix, check_state)
    # ---------------------------------------------------------------------------------
    # Validates if the entered zip code prefix matches that of the state.
    # ---------------------------------------------------------------------------------
    return false if check_state.nil?

    prefix = ZIP_PREFIXES[check_state.upcase]
    return false if prefix.nil?

    prefix.any? { |p| zip_prefix.to_s.start_with?(p) }
  end
end
