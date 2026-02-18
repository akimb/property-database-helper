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
    allowed_extensions = %w[.csv .xlsx]
    file_extension = File.extname(uploaded_file.original_filename).downcase
    
    unless allowed_extensions.include?(file_extension)
      flash[:alert] = "Invalid file type. Please upload a .csv or .xlsx file."
      redirect_to root_path and return
    end
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

  def confirm
    # ---------------------------------------------------------------------------------
    # Validates all properties to prepare for final submission.
    # ---------------------------------------------------------------------------------
    @import = Import.find(params[:id])

    begin 
      ActiveRecord::Base.transaction do
        @import.imported_properties.each do |imported_property|
          property = Property.create!(
            name: imported_property.name,
            street_address: imported_property.street_address,
            city: imported_property.city,
            state: imported_property.state,
            zip_code: imported_property.zip_code
          )

          imported_property.units.each do |imported_unit|
            property.units.create!(
              unit_number: imported_unit.unit_number
            )
          end
        end
        @import.update!(status: "completed")
      end

      redirect_to properties_path, notice: "Import completed successfully."
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Failed to finalize import: #{e.record.errors.full_messages.join(', ')}"
      redirect_to show_final_import_path(@import)
    end
  end

  def show_final
    @import = Import.find(params[:id])

    errors = []
  
    @import.imported_properties.each do |property|
      unless property.valid?
        errors << "Property '#{property.name}': #{property.errors.full_messages.join(', ')}"
      end
      
      unless property.zip_valid
        errors << "Property '#{property.name}': zip code does not match state #{property.state}"
      end
      
      property.units.each do |unit|
        unless unit.valid?
          errors << "Unit #{unit.unit_number} in '#{property.name}': #{unit.errors.full_messages.join(', ')}"
        end
      end
    end

    if errors.any?
      flash[:alert] = errors.join("; ")
      redirect_to import_path(@import) and return
    end
  end

  def new_property
    # ---------------------------------------------------------------------------------
    # New property
    # ---------------------------------------------------------------------------------
    @import = Import.find(params[:id])
    @property = @import.imported_properties.new
  end

  def create_property
    # ---------------------------------------------------------------------------------
    # Creates a new property, and verifies that the zip code is correct
    # based on state dropdown.
    # Uses ActiveRecord transactions to handle errors, i.e. duplicate property names
    # or duplicate units.
    # ---------------------------------------------------------------------------------
    @import = Import.find(params[:id])
    @property = @import.imported_properties.new(imported_property_params)
    @property.zip_valid = CsvImportService.valid_zip?(params[:zip_code], params[:state])
    
    begin
      ActiveRecord::Base.transaction do
        @property.save!

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
      end
        redirect_to import_path(@import)

    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.record.errors.full_messages.join(", ")
      render :new_property, status: :unprocessable_entity
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
    # Uses ActiveRecord transactions to handle errors, i.e. duplicate property names
    # or duplicate units. 
    # ---------------------------------------------------------------------------------
    @import = Import.find(params[:id])
    property_name = params[:original_property_name].presence || params[:property_name]
    @property = @import.imported_properties.find_by!(name: property_name)
    
    begin
      ActiveRecord::Base.transaction do
        if params[:delete_units].present?
          params[:delete_units].each do |unit_id|
            unit = Unit.find_by(id: unit_id)
            unit&.destroy
          end
        end
        
        # using ! will raise an error if found, then use ActiveRecord to handle found error
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
      end

        redirect_to import_path(@import)
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.record.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity      
    end
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
    params.permit(:name, :street_address, :city, :state, :zip_code)
  end

end
