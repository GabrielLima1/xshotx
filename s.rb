require 'watir-webdriver'
require 'webdriver-user-agent'
require 'phantomjs'
#driver = Webdriver::UserAgent.driver(:browser => :chrome, :agent => :iphone, :orientation => :landscape)
driver = Webdriver::UserAgent.driver(:browser => :chrome, :agent => :iphone)
b = Watir::Browser.new driver
b.goto 'instagram.com/accounts/login/'
sleep 2
login = "pagoate"
senha = "123mudar@@"
hashtag = "skina"
# spans[7] = SEGUIDORES | # spans[8] = SEGUINDO
#b.url == 'http://m.tiffany.com/Mobile/Default.aspx'
b.text_field(name: "username").set login
b.text_field(name: "password").set senha
sleep 2
b.button(text: 'Log in').click
controle = 0
numero = 1
sleep 2
begin
	b.goto "https://www.instagram.com/#{hashtag}/"
	sleep 1
rescue
	p "Falha ao Abrir Perfil"
end
sleep 2
#sleep 600
p b.spans[7].text
p b.spans[8].text
sleep 2
b.spans[7].click
sleep 3
if b.button(text: "Follow").present?
	b.button(text: "Follow").click
elsif b.button(text: "Following").present?
	b.button(text: "Following").click
else
	p "Erro na Primeira ação"
end
sleep 2
ale = Random.rand(22...30)
controle = 0

while ale > controle
	begin
		if b.buttons(text: "Follow")[1].present?
			b.buttons(text: "Follow")[1].click
			sleep 1
			controle += 1
			#p controle
		else
			sleep 2
			b.send_keys :end
			sleep 2
		end
	rescue
		#p "Voltando Daqui a Pouco!"
	end
end
p controle