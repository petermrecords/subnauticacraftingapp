# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_30_153105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blueprints", force: :cascade do |t|
    t.integer "material_produced_id", null: false
    t.integer "material_required_id", null: false
    t.integer "number_required", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["material_produced_id", "material_required_id"], name: "uix_blueprints", unique: true
  end

  create_table "byproducts", force: :cascade do |t|
    t.bigint "material_id", null: false
    t.integer "byproduct_id", null: false
    t.integer "number_produced", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["material_id", "byproduct_id"], name: "uix_byproducts", unique: true
    t.index ["material_id"], name: "index_byproducts_on_material_id"
  end

  create_table "list_carryables", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_id"], name: "index_list_carryables_on_list_id"
    t.index ["list_id"], name: "ux_list_carryable", unique: true
  end

  create_table "list_harvestables", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_id"], name: "index_list_harvestables_on_list_id"
    t.index ["list_id"], name: "ux_list_harvestable", unique: true
  end

  create_table "list_materials", force: :cascade do |t|
    t.string "listable_type", null: false
    t.bigint "listable_id", null: false
    t.bigint "material_id", null: false
    t.integer "number_desired", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["listable_id", "listable_type", "material_id"], name: "ux_list_materials", unique: true
    t.index ["listable_type", "listable_id"], name: "index_list_materials_on_listable_type_and_listable_id"
    t.index ["material_id"], name: "index_list_materials_on_material_id"
  end

  create_table "lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "list_name", null: false
    t.text "list_notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "material_name", null: false
    t.string "material_type", null: false
    t.string "material_subtype"
    t.integer "inventory_spaces"
    t.integer "growbed_spaces"
    t.string "wearable_slot"
    t.integer "storage_spaces_provided"
    t.string "crafted_at"
    t.integer "number_produced"
    t.text "material_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["material_name"], name: "index_materials_on_material_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "blueprints", "materials", column: "material_produced_id"
  add_foreign_key "blueprints", "materials", column: "material_required_id"
  add_foreign_key "byproducts", "materials"
  add_foreign_key "byproducts", "materials", column: "byproduct_id"
  add_foreign_key "list_carryables", "lists"
  add_foreign_key "list_harvestables", "lists"
  add_foreign_key "list_materials", "materials"
  add_foreign_key "lists", "users"
end
