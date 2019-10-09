class ListsController < ApplicationController
	def index
		@lists = List.where(user: @user).order(:created)
	end

	def create
		@list = List.new(list_params)
		@list.refresh_harvestable
		@list.refresh_carryable
	end

	def new
		@list = List.new
	end

	def edit
		@list = List.find_by(id: params[:list_id], user: @user)
	end

	def show
		@list = List.find_by(id: params[:list_id], user: @user)
	end

	def update
		@list = List.find_by(params[:list_id], user: @user)
		@list.update_with_versions(list_params)
		redirect_to user_list_path(@user, @list)
	end

	def destroy
		@list = List.find(params[:list_id])
		if @list.destroy
			redirect_to user_lists_path(@user)
		end
	end

	private
	def list_params
		params.require(:list).permit(:list_name, :list_notes, :list_materials)
	end
end
