class ImportsController < ApplicationController
  def new
  end

  def create
    uploaded_file = params[:file]
    import = Import.create!(
      filename: uploaded_file.original_filename,
      raw_csv: uploaded_file.read,
      status: "pending"
    )
    CsvImportService.new(import.raw_csv, import).call

    redirect_to import_path(import)
  end

  def show
    @import = Import.find(params[:id])
  end

  def confirm

  end

  def edit
    @import = Import.find(params[:id])
    @property = @import.imported_properties.find_by!(name: params[:property_name])
  end

  def update
    @import = Import.find(params[:id])
    @property = @import.imported_properties.find_by!(name: params[:property_name])

    # REFACTORED: Use Rails update! to persist changes to database
    # This is much simpler and safer than CSV string reconstruction
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
    @import = Import.find(params[:id])
    import_id = @import.id
    property = @import.imported_properties.find_by!(name: params[:property_name])
    property.destroy

    redirect_to import_path(import_id)
  end
end
