class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :name,   default: "Roberta"
      t.string :email
      t.string :password,   default: "predo12345"

      t.timestamps
    end
  end
end
