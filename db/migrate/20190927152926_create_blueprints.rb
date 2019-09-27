class CreateBlueprints < ActiveRecord::Migration[6.0]
  def change
    create_table :blueprints do |t|
      t.integer :material_produced_id, null: false
      t.integer :material_required_id, null: false
      t.integer :number_required, null: false
      t.timestamps null: false
    end
    add_index :blueprints, [:material_produced_id,:material_required_id], unique: true, name: 'uix_blueprints'
    add_foreign_key :blueprints, :materials, column: :material_produced_id
    add_foreign_key :blueprints, :materials, column: :material_required_id
  end
end
