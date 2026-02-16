class MakePropertyidNullable < ActiveRecord::Migration[8.1]
  def change
    change_column :units, :property_id, :bigint, null: true
  end
end
