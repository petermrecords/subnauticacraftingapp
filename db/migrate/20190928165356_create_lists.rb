class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
    	t.references :user, null: false, foreign_key: true
    	t.string :list_name, null: false
    	t.text :list_notes
      t.timestamps null: false
    end
  end
end
