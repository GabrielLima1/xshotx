class Type < ApplicationRecord
  validates_presence_of :name, :message, message: 'Ops! Preencha esse Aqui!'
	has_many :robots
end
