class CreateListMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :list_materials do |t|
      t.references :listable, polymorphic: true, null: false
      t.references :material, null: false, foreign_key: true
      t.integer :number_desired, null: false, default: 1
      t.timestamps null: false
    end
    add_index :list_materials, [:listable_id, :listable_type, :material_id], unique: true, name: 'ux_list_materials'
  end
end
