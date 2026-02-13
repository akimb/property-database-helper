class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.string :name, null: false # prevent blank properties from being accepted
      t.string :address

      t.timestamps
    end

    add_index :properties, :name, unique: true # make each property unique
  end
end
