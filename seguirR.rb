#encoding:utf-8
p "Robo Versão '2.0.2'"
require 'rubygems'
require 'io/console'
require 'watir-webdriver'

if STDIN.respond_to?(:noecho)
  def get_password(prompt="Password: ")
    print prompt
    STDIN.noecho(&:gets).chomp
  end
else
  def get_password(prompt="Password: ")
    `read -s -p "#{prompt}" password; echo $password`.chomp
  end
end

novo = "s"
while novo == "s"
	p "Passe o Login"
	login = gets.chomp
	senha = get_password
	p "********"
	p "Deseja alterar algum dado acima?(s/n)"
	novo = gets.chomp
end
erros = []
novo = "s"
while novo == "s"
	p "Passe o perfil que deseja SEGUIR"
	hastag = gets.chomp
	p "Deseja alterar algo ? (s/n)"
	novo = gets.chomp
end
puts "Aguarde..."
b = Watir::Browser.new :phantomjs
b.goto "https://www.instagram.com/accounts/login/"
sleep 2
begin
	b.text_field(placeholder: 'Username').set "#{login}" #preencher
	b.text_field(placeholder: 'Password').set "#{senha}" #preencher
	b.button(text: 'Log in').click
	sleep 2
	if b.url == "https://www.instagram.com/accounts/login/"
		p erros << "Erro no Login! Tentando efetuar Login Novamente!"
		b.text_field(placeholder: 'Username').set "#{login}" #preencher
		b.text_field(placeholder: 'Username').set "#{senha}" #preencher
		b.button(text: 'Log in').click
		sleep 2
	else
		p "Login Feito!"
    sleep 3
    p b.url
    insta = "n"
    if b.url.include? "integrity/checkpoint"
      while insta == "n"
      	p "Eai posso sair ?"
      	insta = gets.chomp
      end
    else
      p "Foi"
    end
	end
rescue
	p erros << "Erro no Login!"
end
numero = 0
controle = 0
begin
	b.goto "https://www.instagram.com/#{hastag}/"
rescue
	erros << "Falha ao Abrir Link Inicial"
end
begin
	#pegando links de pessoas
	p span = b.link(class: "_s53mj").present?
	p span = b.link(class: "_s53mj").text
	sleep 1
	if span.include? "milhões"
		p "milhões"
		span = span.gsub("m followers","")
		#span = span.to_i
		span = span.to_i * 1000000
		span = (span / 2)-100
	elsif span.include? "mil"
		p "mil"
		span = span.gsub("k\nfollowers","")
		#span = span.to_i
		span = span.to_i * 1000
		span = (span / 2)-100
  else
    span = b.link(class: "_s53mj").text
    span = span.gsub("followers","").gsub(".","")
    span = span.to_i
	end
	p span
rescue
	erros << "Falha ao Pegar Valor de followers!"
end
b.close
sleep 1
while numero < span
  b = Watir::Browser.new :phantomjs
  b.goto "https://www.instagram.com/accounts/login/"
  sleep 2
  begin
  	b.text_field(placeholder: 'Nome de usuário').set "#{login}" #preencher
  	b.text_field(placeholder: 'Senha').set "#{senha}" #preencher
  	b.button(text: 'Entrar').click
  	sleep 2
  	if b.url == "https://www.instagram.com/accounts/login/"
  		erros << "Erro no Login! Tentando efetuar Login Novamente!"
  		b.text_field(placeholder: 'Nome de usuário').set "#{login}" #preencher
  		b.text_field(placeholder: 'Senha').set "#{senha}" #preencher
  		b.button(text: 'Entrar').click
  		sleep 2
  	else
  		p "Login Feito!"
  	end
  rescue
  	erros << "Erro no Login!"
  end
  begin
  	b.goto "https://www.instagram.com/#{hastag}/"
    sleep 2
  rescue
  	p erros << "Falha ao Abrir Link Inicial"
  end
  sleep 3
  p "Url: #{b.url}"
  p b.link(href: "/#{hastag}/followers/").first.present?
  p b.link(href: "/#{hastag}/followers/").first.text
  sleep 3
  b.link(href: "/#{hastag}/followers/").first.click
  sleep 3
  if b.buttons(text: "Follow")[1].present?
    b.buttons(text: "Follow")[1].click
  else
    b.buttons(text: "Following")[1].click
  end
  sleep 3
  total = b.buttons(text: "Follow").length
	ale = Random.rand(22...30)
	while controle <  ale
		begin
			if b.buttons(text: "Follow")[1].present?
				b.buttons(text: "Follow")[1].click
				sleep 1
				p controle += 1
				numero += 1
				#p controle
			else
        sleep 1
				b.send_keys :end
				sleep 2
				b.send_keys :end
			end
		rescue
			#p "Voltando Daqui a Pouco!"
		end
	end
	controle = 0
	b.send_keys :end
	sleep 2
	b.send_keys :end
  b.close
	p "Aguarde 30 Minutos..."
  p papapa = Random.rand(2000...2200)
	sleep papapa
	p "Iniciando Novamente..."
end

sleep 1
if erros.length == 0
	p "Nenhum erro!"
else
	p "#{erros.length} - Erro(s)"
	erros.each do |a|
	end
end
b.close
p "Fim - Teste!"
#._ovg3g #imgs