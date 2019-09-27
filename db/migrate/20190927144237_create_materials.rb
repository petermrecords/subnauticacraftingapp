class CreateMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :materials do |t|
      t.string :material_name, null: false
      t.string :material_type, null: false
      t.string :material_subtype
      t.integer :inventory_spaces
      t.integer :growbed_spaces
      t.string :wearable_slot
      t.integer :storage_spaces_provided
      t.string :crafted_at
      t.integer :number_produced
      t.text :material_description
      t.timestamps null: false
    end
    add_index :materials, :material_name, unique: true
  end
end
