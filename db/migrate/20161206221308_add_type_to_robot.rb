class AddTypeToRobot < ActiveRecord::Migration[5.0]
  def change
    add_reference :robots, :type, foreign_key: true
  end
end
