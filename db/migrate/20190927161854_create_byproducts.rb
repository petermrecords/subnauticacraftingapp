class CreateByproducts < ActiveRecord::Migration[6.0]
  def change
    create_table :byproducts do |t|
      t.references :material, null: false, foreign_key: true
      t.integer :byproduct_id, null: false
      t.integer :number_produced, null: false
      t.timestamps null: false
    end
    add_index :byproducts, [:material_id,:byproduct_id], unique: true, name: 'uix_byproducts'
    add_foreign_key :byproducts, :materials, column: :byproduct_id
  end
end
