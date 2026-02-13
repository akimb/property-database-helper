class ImportsController < ApplicationController
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

  # def confirm

  # end

  def new_property
    @import = Import.find(params[:id])
    @property = @import.imported_properties.new
  end

  def create_property
    @import = Import.find(params[:id])
    @property = @import.imported_properties.new(imported_property_params)
    @property.zip_valid = CsvImportService.valid_zip?(params[:zip_code], params[:state])
    
    if @property.save
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
    @import = Import.find(params[:id])
    @property = @import.imported_properties.find_by!(name: params[:property_name])

    @property.update!(
      name: params[:name],
      street_address: params[:street_address],
      city: params[:city],
      state: params[:state],
      zip_code: params[:zip_code],
      zip_valid: CsvImportService.valid_zip?(params[:zip_code], params[:state])
    )

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
    params.permit(:name, :street_address, :city, :state, :zip_code, units: [])
  end
end
