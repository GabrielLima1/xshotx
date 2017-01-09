# Encoding: UTF-8
p "Robo Versão '1.0.1'"
require 'rubygems'
require 'io/console'
require 'watir-webdriver'
require 'mechanize'
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
mensagem_email = "foi APROVADO!!!
Aguarde que logo logo seu pedido chegará em sua residência. Dúvidas sobre prazo de envio ou sobre o pedido acesse nosso campo PERGUNTAS FREQUENTES em nosso site : http://mistermattpulseiras.com.br/perguntas-frequentes/"
mensagem_wpp = "Email já Coletado!"

login_wpp = "admin"
senha_wpp = "alma1505@12#12"

login_email = "mistermattpulseiras"
senha_email = "analima@123"

links = []
emails = []
numero = 1
antigos = 0
novos = 0
p "Aguarde..."
# FAZENDO LOGIN NO WPP
@b = Watir::Browser.new :phantomjs
Watir.default_timeout = 90
@b.window.maximize

@b.goto "http://mistermattpulseiras.com.br/wp-login.php"
@b.text_field(name: "log").set login_wpp
@b.text_field(name: "pwd").set senha_wpp
@b.button(type: "submit").click
sleep 2
p "Login no WPP Feito"
# FAZENDO LOGIN NO GMAIL
@b.goto "mail.google.com"
sleep 2
p @b.url
@b.text_field(name: "Email").set login_email
@b.button(type: "submit").click
sleep 2
@b.text_field(name: "Passwd").set senha_email
@b.button(text: "Sign in").click
sleep 2
p "Login no Gmail Feito"
while numero < 4
  sleep 2
  @b.goto "http://mistermattpulseiras.com.br/wp-admin/edit.php?s&post_status=wc-processing&post_type=shop_order&action=-1&m=201701&_customer_user&filter_action=Filtrar&paged=1&action2=-1&paged=#{numero}"
  sleep 3
  @b.links(text: "Visualizar").each do |link|
    links << link.href
  end
  p links.count
  links.each do |link|
    @b.goto link
    sleep 2
    if @b.p(text: "Email Enviado!").present?
      if @b.span(text: "Processando").present?
        @b.span(text: "Processando").click
        sleep 2
        @b.div(text: "Aguardando").click
        sleep 1
        @b.button(text: "Salvar Pedido").click
        sleep 5
      else
        p "Já fazido!"
        break
        break
      end
    elsif @b.p(text: "Email já Coletado!").present?
      sleep 2
      @b.span(text: "Processando").click
      sleep 2
      @b.div(text: "Aguardando").click
      sleep 1
      @b.textarea(name: "order_note"). set "Email Enviado!"
      sleep 1
      #@b.select_list(name: 'order_note_type').select 'Nota para o cliente'
      #sleep 1
      @b.link(text: "Adicionar").click
      sleep 2
      @b.send_keys :home
      sleep 2
      @b.button(text: "Salvar Pedido").click
      sleep 5
      # VER SE ESTA TUDO OK SE NAÕ NÃO PRECISA COLOCAR O SLEEP
    else
      # VER SE ESTA TUDO OK SE NAÕ NÃO PRECISA COLOCAR O SLEEP
      sleep 2
      div = @b.div(id: "order_data")
      numero_pedido = div.h2s.first.text.gsub("Detalhes do Pedido ", "")
      @b.links(text: "Editar").first.click
      sleep 2
      nome = @b.text_field(id: "_billing_first_name").value
      email = @b.text_field(id: "_billing_email").value
      sleep 2
      @b.goto "gmail.com"
      sleep 3
      @b.div(text: "ESCREVER").click
      sleep 1
      form = @b.forms[3]
      form.text_fields[1].set email
      form.text_field(name: "subjectbox").set "Confimação do Pedido"
      @b.send_keys :tab
      sleep 2
      @b.send_keys "Olá #{nome}"
      @b.send_keys [:shift, :enter]
      @b.send_keys "O Pedido #{numero_pedido} #{mensagem_email}"
      sleep 2
      @b.send_keys [:control, :enter]
      sleep 2
      #VOLTANDO PARA O WPP

      @b.goto link
      sleep 2
      @b.span(text: "Processando").click
      sleep 2
      @b.div(text: "Aguardando").click
      sleep 1
      @b.textarea(name: "order_note"). set "Email Enviado!"
      sleep 1
      #@b.select_list(name: 'order_note_type').select 'Nota para o cliente'
      #sleep 1
      @b.link(text: "Adicionar").click
      sleep 2
      @b.send_keys :home
      sleep 2
      @b.button(text: "Salvar Pedido").click
      sleep 6
      p "Feito"
    end
  end
  numero += 1
  links.clear
end
p "Acabouuuuuu!"
@b.close
