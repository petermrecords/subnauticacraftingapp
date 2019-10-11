module ListMaterialsHelper
  def maint_path(list, list_material)
    list_material.id ? list_list_material_path(list, list_material) : list_list_materials_path(list)
  end
end
