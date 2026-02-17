require 'csv'

class PropertiesController < ApplicationController

  def index
    @properties = Property.all.includes(:units)
  end

  def destroy_all
    Property.destroy_all
    redirect_to properties_path, notice: "All properties deleted."
  end

  def export
    @properties = Property.all.includes(:units)
    respond_to do |format|
      format.csv do 
        send_data generate_csv(@properties), 
        filename: "Finalized_Properties_#{Date.today}.csv",
        type: "text/csv"
      end
    end
  end

  private

  def generate_csv(properties)
    CSV.generate(headers:true) do |csv|
      csv << ["Building Name", "Street Address", "Unit", "City", "State", "Zip Code"]

      properties.each do |property|
        if property.units.any?
          property.units.each do |unit|
            csv << [
              property.name,
              property.street_address,
              unit.unit_number,
              property.city,
              property.state,
              property.zip_code
            ]
          end
        else
          csv << [
            property.name,
            property.street_address,
            nil,
            property.city,
            property.state,
            property.zip_code
            ]
        end
      end
    end
  end
end
