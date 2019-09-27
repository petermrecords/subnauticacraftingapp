# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

Blueprint.destroy_all
$stdout.puts "Blueprints cleared"
Byproduct.destroy_all
$stdout.puts "Byproducts cleared"
Material.destroy_all
$stdout.puts "Materials cleared"

CSV.foreach(Rails.root.join('lib','seeds','subnautica_materials.csv'), headers: true) do |row|
  begin
    Material.create!({
      material_name: row[0],
      material_type: row[1],
      material_subtype: row[2],
      inventory_spaces: row[3],
      growbed_spaces: row[4],
      wearable_slot: row[5],
      storage_spaces_provided: row[6],
      crafted_at: row[7],
      number_produced: row[8],
      material_description: row[9]
    })
    $stdout.puts "#{row[0]} created"
  rescue ActiveRecord::RecordInvalid => e
    raise StandardError.new "#{row[0]} could not be created: #{e.message}"
  end
end

CSV.foreach(Rails.root.join('lib','seeds','subnautica_blueprints.csv'), headers: true) do |row|
  begin
    Blueprint.create!({
      material_produced: Material.find_by(material_name: row[0]),
      material_required: Material.find_by(material_name: row[1]),
      number_required: row[2]
    })
    $stdout.puts "#{row[1]} added as a material for #{row[0]}"
  rescue ActiveRecord::RecordInvalid => e
    raise StandardError.new "#{row[1]} could not be added as a material for #{row[0]}: #{e.message}"
  end
end

CSV.foreach(Rails.root.join('lib','seeds','subnautica_byproducts.csv'), headers: true) do |row|
  begin
    Byproduct.create!({
      material: Material.find_by(material_name: row[0]),
      byproduct: Material.find_by(material_name: row[1]),
      number_produced: row[2]
    })
    $stdout.puts "#{row[1]} added as byproduct for #{row[0]}"
  rescue
    raise StandardError.new "#{row[1]} could not be added as byproduct for #{row[0]}: #{e.message}"
  end
end