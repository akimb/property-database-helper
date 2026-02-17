class AddMoreAttributesToProperties < ActiveRecord::Migration[8.1]
  def change
    add_column :properties, :street_address, :string
    add_column :properties, :city, :string
    add_column :properties, :state, :string
    add_column :properties, :zip_code, :string
  end
end
