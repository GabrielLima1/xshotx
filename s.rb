require 'watir-webdriver'
#require 'phantomjs'
# spans[7] = SEGUIDORES | # spans[8] = SEGUINDO

@b = Watir::Browser.new :phantomjs
Watir.default_timeout = 90
#@b.window.maximize

# Quick test to make sure it's set

#b = Watir::Browser.new driver
@b.goto 'www.instagram.com/accounts/login/'
sleep 5
sleep 2
p @b.url
if @b.url.include? "/accounts/login/"
	p "Entrei no If"
	sleep 4
	login = "pagoate"
	senha = "123mudar@@"
	hashtag = "skina"
	p @b.span(text: "Log in as #{login}").present?
	p @b.button(text: "Log in as #{login}").present?
	sleep 5
	p "-----INGLES--------"
	p @b.text_field(placeholder: "Username").present?
	p @b.text_field(placeholder: "Password").present?
	p @b.button(placeholder: "Log in").present?
	sleep 3
	p "-----PORTUGUÊS--------"
	p @b.text_field(placeholder: 'Nome de usuário')present?
	p @b.text_field(placeholder: 'Senha')present?
	p @b.button(text: 'Entrar')present?
	p "-----------------"

end
p @b.url
p @b.link(text: "Profile").present?
body = @b.body
body.inputs.each do |input|
  p input.name
end
#
# # controle = 0
# # numero = 1
# # sleep 2
# begin
# 	@b.goto "https://www.instagram.com/#{hashtag}/"
# 	sleep 1
# rescue
# 	p "Falha ao Abrir Perfil"
# end
# sleep 2
# #sleep 600
# p @b.link(text: "Profile").present?
# p @b.spans[7].text
# p @b.spans[8].text
# sleep 2
# @b.spans[7].click
# # sleep 3
# # if @b.button(text: "Follow").present?
# # 	@b.button(text: "Follow").click
# # elsif @b.button(text: "Following").present?
# # 	@b.button(text: "Following").click
# # else
# # 	p "Erro na Primeira ação"
# # end
# # sleep 2
# # ale = Random.rand(22...30)
# # controle = 0
# #
# # while ale > controle
# # 	begin
# # 		if @b.buttons(text: "Follow")[1].present?
# # 			@b.buttons(text: "Follow")[1].click
# # 			sleep 1
# # 			controle += 1
# # 			#p controle
# # 		else
# # 			sleep 2
# # 			@b.send_keys :end
# # 			sleep 2
# # 		end
# # 	rescue
# # 		#p "Voltando Daqui a Pouco!"
# # 	end
# # end
# # p controle
p "Fim"
@b.close
