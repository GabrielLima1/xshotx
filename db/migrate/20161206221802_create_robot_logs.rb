class CreateRobotLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :robot_logs do |t|
      t.integer :done_chat
      t.integer :fail_chat
      t.string :message
      t.integer :pulados, default: 0

      t.timestamps
    end
  end
end
