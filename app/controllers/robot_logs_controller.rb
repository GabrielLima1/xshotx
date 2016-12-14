class RobotLogsController < ApplicationController
  before_action :set_robot_log, only: [:show, :destroy]
def index
  @robot_logs = RobotLog.paginate(:page => params[:page], :per_page => 10)
														      .order(created_at: :asc)
end

def show
  respond_with @robot_logs
  #respond_with @robot_logs
end

def destroy
  @robot_log.destroy
  redirect_to robot_logs_path, alert: "Log deletado"
end

private

def set_robot_log
  @robot_log = RobotLog.find(params[:id])
end
end
