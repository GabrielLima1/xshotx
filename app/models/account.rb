class Account < ApplicationRecord
  validates_presence_of :name, :email, message: 'Ops! Preencha esse Aqui!'
  validates_uniqueness_of :email, message: 'E-mail Já Existe!'

	def self.create_contas(params)
		contas = params[:email].split(" ")
		contas.each do |w|
		  self.create(email: w)
		end
	end
end
