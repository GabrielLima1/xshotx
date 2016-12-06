class AccountsController < ApplicationController
  before_action :set_account, only: [:edit, :update, :show, :destroy]

	def new
		@account = Account.new
	end

	def create
		@account = Account.create_contas(account_params)
		#respond_with @account
		flash[:success] = 'Contas Criadas.'
		redirect_to accounts_path
	end

	def update
		@account.update(account_params)
    	respond_with @account
	end

	def show
		respond_with @account
	end


	def index
		#@accounts = Account.all.order(:created_at)
		 @accounts = Account.paginate(:page => params[:page])
                              		.order(created_at: :asc)
	end

	def destroy
		@account.destroy
		redirect_to accounts_path, alert: "Conta Deletada"
	rescue
		redirect_to accounts_path, alert: "Não foi possivel deletar"
	end

	private
	def set_account
		@account = Account.find(params[:id])
	end

	def account_params
		params.require(:account).permit(:name, :email)
	end
end
