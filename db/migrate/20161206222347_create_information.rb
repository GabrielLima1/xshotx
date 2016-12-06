class CreateInformation < ActiveRecord::Migration[5.0]
  def change
    create_table :information do |t|
      t.string :cep,      default: "0-0"
      t.string :usuario,  default: "user"

      t.timestamps
    end
  end
end
