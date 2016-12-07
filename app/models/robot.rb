class Robot < ApplicationRecord
  validates_presence_of :name, :search, :page_start, :page_finish, :type, message: 'Ops! Preencha esse Aqui!'
	belongs_to :type
	has_many :robot_logs
	#has_many :informations
end
