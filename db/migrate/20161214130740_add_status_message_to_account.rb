class AddStatusMessageToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :status_message, :boolean, default: false
  end
end
