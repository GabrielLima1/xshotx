class CreateRobots < ActiveRecord::Migration[5.0]
  def change
    create_table :robots do |t|
      t.string :name
      t.integer :page_start
      t.integer :page_finish
      t.boolean :automatic,   default: false
      t.string :search
      t.boolean :status
      t.string :nosearch,     default: ""
      t.integer :page_number, default: 0

      t.timestamps
    end
  end
end
