class ListMaterialsController < ApplicationController
  def create
    @list_material = ListMaterial.new(list_material_params)
    @list = List.find(params[:list_id])
    @material_type_select = Material.material_types_select
    @material_select = Material.materials_select
    @list_material = ListMaterial.new if @list_material.save
    respond_to do |format|
      format.js
    end
  end

  def update
    @list_material = ListMaterial.find_by(listable: params[:list_id], id: params[:list_material_id])
    @list_material.update(list_material_params)
    @list = List.find(params[:list_id])
    @material_type_select = Material.material_types_select
    @material_select = Material.materials_select
    @list_material = ListMaterial.new if @list_material.save
    respond_to do |format|
      format.js { render :create }
    end
  end

  def destroy
  end

  private

  def list_material_params
    params.require(:list_material).permit(:listable_id, :listable_type, :material, :number_desired)
  end
end
