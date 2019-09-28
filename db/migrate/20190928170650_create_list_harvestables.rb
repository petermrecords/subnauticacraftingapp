class CreateListHarvestables < ActiveRecord::Migration[6.0]
  def change
    create_table :list_harvestables do |t|
    	t.references :list, null: false, foreign_key: true
      t.timestamps null: false
    end
    add_index :list_harvestables, :list_id, unique: true, name: 'ux_list_harvestable'
  end
end
