class InformationsController < ApplicationController
  before_action :set_information, only: [:show, :destroy]
  def index
    @informations = Information.paginate(:page => params[:page], :per_page => 1)
                               .order(created_at: :desc)
  end

  def show
    respond_with @informations
    #respond_with @informations
  end

  def destroy
    @information.destroy
    redirect_to informations_path, alert: "Deletado!"
  end

  private

  def set_information
    @information = Information.find(params[:id])
  end
end
