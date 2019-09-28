class CreateListCarryables < ActiveRecord::Migration[6.0]
  def change
    create_table :list_carryables do |t|
    	t.references :list, null: false, foreign_key: true
      t.timestamps null: false
    end
    add_index :list_carryables, :list_id, unique: true, name: 'ux_list_carryable'
  end
end
