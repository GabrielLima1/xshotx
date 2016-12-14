class AddRobotToInformation < ActiveRecord::Migration[5.0]
  def change
    add_reference :information, :robot, foreign_key: true
  end
end
