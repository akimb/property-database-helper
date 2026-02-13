require "csv"

class CsvParserService

  def initialize(raw_csv)
    @raw_csv = raw_csv # the @ is kind of like self in Python
  end

  def call
    rows = CSV.parse(@raw_csv, headers: true) # parses into rows and keeps headers
    properties = {}

    rows.each do |row|
      property_name = clean_information(row["Building Name"], true)
      unit_number = row["Unit"]
      street_address = clean_information(row["Street Address"])
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
        zip_valid: valid_zip?(zip_code, state)
      } # ||= means that if it doesn't already exist, add it
      
      properties[property_name][:units] << unit_number unless unit_number.nil? || unit_number.empty? # appends units to the hash
    end

    properties.values
  end
