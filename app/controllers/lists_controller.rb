class ListsController < ApplicationController
	before_action do
		@user ||= current_user
	end

	def index
	end

	def create
		@list = List.new(list_params)
		# create the carryable
		# create the harvestable
		# validate and save it all
	end

	def new
		@list = List.new
	end

	def edit
		@list = List.find(params[:list_id])
	end

	def show
		@list = List.find(params[:list_id])
	end

	def update
		@list = List.find(params[:list_id])
		# update the list
		# recalc the carryable if the materials have changed
		# recalc the harvestable if the materials have changed
	end

	def destroy
		@list = List.find(params[:list_id])
		if @list.destroy
			redirect_to user_lists_path(@user)
		end
	end

	private
	def list_params
		params.require(:list).permit(:list_name, :list_notes)
	end
end
