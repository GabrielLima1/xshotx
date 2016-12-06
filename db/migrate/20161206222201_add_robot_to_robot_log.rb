class AddRobotToRobotLog < ActiveRecord::Migration[5.0]
  def change
    add_reference :robot_logs, :robot, foreign_key: true
  end
end
