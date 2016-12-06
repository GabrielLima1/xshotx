class TypesController < ApplicationController
  before_action :set_type, only: [:edit, :update, :show, :destroy]

	def new
		@type = Type.new
	end

	def create
		@type = Type.create(type_params)
		respond_with @type
	end

	def update
		@type.update(type_params)
    	respond_with @type
	end

	def show
		respond_with @type
	end


	def index
		@types = Type.paginate(:page => params[:page], :per_page => 10)
														 .order(created_at: :asc)
	end

	def destroy
		@type.destroy
		redirect_to types_path, alert: "Type Deletado"
	rescue
		redirect_to types_path, alert: "Não foi possivel deletar"
	end

	private
	def set_type
		@type = Type.find(params[:id])
	end

	def type_params
		params.require(:type).permit(:name, :message)
	end
end
