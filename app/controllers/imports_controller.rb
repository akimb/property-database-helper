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

    redirect_to import_path(import)
  end

  def show
    @import = Import.find(params[:id])
    @parsed = CsvParserService.new(@import.raw_csv).call
  end

  def confirm

  end

  def edit
    @import = Import.find(params[:id])
    @parsed = CsvParserService.new(@import.raw_csv).call
    @property = @parsed.find { |p| p[:name] == params[:property_name]}
  end

  def update
    @import = Import.find(params[:id])
    rows = CSV.parse(@import.raw_csv, headers: true)

    rows.each do |row|
      if row["Building Name"].to_s.upcase.gsub(/[^A-Za-z0-9\s]/, '') == params[:property_name]
        row["Building Name"] = params[:name]
        row["Street Address"] = params[:street_address]
        row["City"] = params[:city]
        row["State"] = params[:state]
        row["Zip Code"] = params[:zip_code]
      end
    end

    @import.update!(raw_csv: rows.to_csv)
    redirect_to import_path(@import)
  end

  def destroy
    @import = Import.destroy(params[:id])
  end
end
