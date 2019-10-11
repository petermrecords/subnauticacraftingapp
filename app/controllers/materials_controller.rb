class MaterialsController < ApplicationController
  def select
    @material_select = Material.materials_select(params[:material_type])
    respond_to do |format|
      format.js
    end
  end
end
