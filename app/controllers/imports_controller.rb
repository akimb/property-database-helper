class ImportsController < ApplicationController
  include TextCleaner

  def new
  end

  def create
    # ---------------------------------------------------------------------------------
    # Creates a new database based on importing the raw CSV.
    # Then calls the CsvImportService controller and creates an
    # ImportProperty for each row. 
    # ---------------------------------------------------------------------------------
    uploaded_file = params[:file]
    import = Import.create!(
      filename: uploaded_file.original_filename,
      raw_csv: uploaded_file.read, # keep original csv if desired
      status: "pending"
    )
    CsvImportService.new(import.raw_csv, import).call

    redirect_to import_path(import)
  end

  def show
    # ---------------------------------------------------------------------------------
    # Method to list out all properties in the database.
    # ---------------------------------------------------------------------------------
    @import = Import.find(params[:id])
  end


  def new_property
    @import = Import.find(params[:id])
    @property = @import.imported_properties.new
  end

  def create_property
    @import = Import.find(params[:id])
    @property = @import.imported_properties.new(imported_property_params)
    @property.zip_valid = CsvImportService.valid_zip?(params[:zip_code], params[:state])
        
    if @property.save
      
      @property.update!(
        name: clean_information(params[:name], true),
        street_address: clean_information(params[:street_address], true),
        city: clean_information(params[:city], true)
      )
      if params[:units].present?
        params[:units].each do |_, unit_params|
          unit_number = unit_params[:unit_number].strip
          @property.units.create!(unit_number: unit_number) unless unit_number.empty?
        end
      end

      redirect_to import_path(@import)
    else
      render :new_property
    end
  end
  
  def edit
    # ---------------------------------------------------------------------------------
    # Method to access the edit form by the property name as its unique identifier
    # ---------------------------------------------------------------------------------
    @import = Import.find(params[:id])
    @property = @import.imported_properties.find_by!(name: params[:property_name])
  end

  def update
    # ---------------------------------------------------------------------------------
    # method: :patch method recognized by Rails.
    # The specific property is found, then uses the update! method via Rails
    # to persist changes to the database.
    # ---------------------------------------------------------------------------------
    # Rails.logger.debug params.inspect
    # render plain: params.inspect

    @import = Import.find(params[:id])
    @property = @import.imported_properties.find_by!(name: params[:property_name])

    if params[:delete_units].present?
      params[:delete_units].each do |unit_id|
        unit = Unit.find_by(id: unit_id)
        unit&.destroy
      end
    end

    @property.update!(
      name: clean_information(params[:name], true),
      street_address: clean_information(params[:street_address], true),
      city: clean_information(params[:city], true),
      state: clean_information(params[:state], true),
      zip_code: params[:zip_code],
      zip_valid: CsvImportService.valid_zip?(params[:zip_code], params[:state])
    )
    
    if params[:units].present?
      deleted_ids = params[:delete_units]&.map(&:to_s) || []
      params[:units].each do |id, unit_params|
        next if deleted_ids.include?(id.to_s)
        unit_number = unit_params[:unit_number].to_s.strip
                
        next if unit_number.blank?

        if id.start_with?("new_")
          @property.units.create!(unit_number: unit_number)
        else
          unit = Unit.find_by(id: id)
          unit.update!(unit_number: unit_number)
        end
      end
    end
    redirect_to import_path(@import)
  end

  def destroy
    # ---------------------------------------------------------------------------------
    # Method to delete a property. Gets an instance of the property, 
    # hence the lack of '@' on the property variable.
    # ---------------------------------------------------------------------------------
    @import = Import.find(params[:id])
    import_id = @import.id
    property = @import.imported_properties.find_by!(name: params[:property_name])
    property.destroy

    redirect_to import_path(import_id)
  end

  private

  def imported_property_params
    # params.require(:imported_property).permit(:name, :street_address, :city, :state, :zip_code, units: [])
    params.permit(:name, :street_address, :city, :state, :zip_code)
  end

end
