class UnitsController < ApplicationController

  before_action :set_import
  before_action :set_unit, only: [:destroy]
  
  def new
    @imported_property = @import.imported_properties.find(params[:imported_property_id])
    @unit = @imported_property.units.build
  end

  def create
    @imported_property = @import.imported_properties.find(params[:imported_property_id])
    @unit = @imported_property.units.build(unit_params)
    @unit.import = @import

    if @unit.save
      redirect_to import_path(@import), notice: 'Unit(s) added successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # import = @unit.import
    property_name = @unit.imported_property.name
    @unit.destroy
    redirect_to edit_import_path(@import, property_name: property_name), notice: 'Units deleted successfully.'
  end

  private

  def set_import
    @import = Import.find(params[:import_id])
  end

  def set_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:unit_number)
  end

end