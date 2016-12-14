class RobotsController < ApplicationController
  before_action :set_robot, only: [:edit, :update, :show, :destroy, :enabled_status]

	def new
		@robot = Robot.new
	end

	def create
		@robot = Robot.create(robot_params)
		respond_with @robot
	end

	def update
		@robot.update(robot_params)
    	respond_with @robot
	end

	def show
		#@robot_logs = @robot.robot_logs.order(created_at: :desc)
		respond_with @robot
	end
	def complete_name
		"#{name}, #{page_finish}"
	end
	def contas_necessarias
		 @robots.each do |robot|
		 num_P = robot.page_finish
		 num_P-=1
		 num_G = robot.page_start
		 variacao = num_G-num_P
		 total = total.to_i+variacao.to_i
		 p total
		end
	end

	def index
		@robots = Robot.paginate(:page => params[:page], :per_page => 10)
														 .order(created_at: :asc)
	end

	def destroy
		@robot.destroy
		redirect_to robots_path, alert: "Robot Deletado"
	rescue
		redirect_to robots_path, alert: "Não foi possivel deletar"
	end

	def enabled_status
    case params[:status]
    when 'true'
			#@robot = Robot.find(params[:id])
			@robot.status = "true"
			#false
    when 'false'
			#@robot = Robot.find(params[:id])
			@robot.status = "false"
			#false
    else
      redirect_to :back
    end
		redirect_to :back
    @robot.save
  end

	private
	def set_robot
		@robot = Robot.find(params[:id])
	end

	def robot_params
		params.require(:robot).permit(:name, :search, :nosearch, :page_start, :page_finish, :page_number, :automatic, :status, :type_id, :search)
	end
end
