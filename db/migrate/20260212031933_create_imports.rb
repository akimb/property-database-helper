class CreateImports < ActiveRecord::Migration[8.1]
  def change
    create_table :imports do |t|
      t.string :status, null: false, default: "pending" # make pending by default
      t.string :filename
      t.text :raw_csv
      t.timestamps
    end
  end
end
