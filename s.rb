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
mensagem_email = "Aguarde que logo logo seu pedido chegará em sua residência. Dúvidas sobre prazo de envio ou sobre o pedido acesse nosso campo PERGUNTAS FREQUENTES em nosso site : http://mistermattpulseiras.com.br/perguntas-frequentes/"

login_wpp = "admin"
senha_wpp = "alma1505@12#12"


links = []
emails = []
numero = 1
antigos = 0
novos = 0
month = { "janeiro" => "01", "fevereiro" => "02", "março" => "03", "abril" => "04",
        "maio" => "05", "junho" => "06", "julho" => "07", "agosto" => "08", "setembro" => "09",
         "outubro" => "10", "novembro" => "11", "dezembro" => "12"}
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
#http://mistermattpulseiras.com.br/wp-admin/edit.php?s&post_status=wc-processing&post_type=shop_order&action=-1&m=201701&_customer_user&filter_action=Filtrar&paged=1&action2=-1

@b.goto "http://mistermattpulseiras.com.br/wp-admin/edit.php?s&post_status=wc-processing&post_type=shop_order&action=-1&m=201701&_customer_user&filter_action=Filtrar&paged=#{numero}&action2=-1"
sleep 4
p final = @b.span(class: "total-pages").text
final = final.to_i

while numero <= final
  begin
    @b.goto "http://mistermattpulseiras.com.br/wp-admin/edit.php?s&post_status=wc-processing&post_type=shop_order&action=-1&m=201701&_customer_user&filter_action=Filtrar&paged=#{numero}&action2=-1"
    sleep 2
    @b.links(text: "Visualizar").each do |link|
      links << link.href
    end
    p links.length
    numero += 1
  rescue
  end
end
p links.length

links.each do |link|
  begin
    @b.goto link
    sleep 3
    if @b.p(text: "Email Enviado!").present? && @b.span(text: "Processando").present?
      @b.span(text: "Processando").click
      sleep 2
      @b.div(text: "Aguardando").click
      sleep 1
      @b.button(text: "Salvar Pedido").click
      sleep 5
    else
      # VER SE ESTA TUDO OK SE NAÕ NÃO PRECISA COLOCAR O SLEEP
      sleep 2
      p "Entrei"
      @b.links(text: "Editar").first.click
      sleep 1
      nome = @b.text_field(id: "_billing_first_name").value
      @b.refresh
      sleep 2
      @b.span(text: "Processando").click
      sleep 2
      @b.div(text: "Aguardando").click
      sleep 2
      div = @b.div(id: "order_data")
      numero_pedido = div.h2s.first.text.gsub("Detalhes do Pedido ", "")
      data = @b.p(class: "order_number").text
      data = data.split("em").last.split("às").first.lstrip.strip
      data = data.gsub(" de ","/")
      mes = data.split("/")[1]
      data = data.gsub("#{mes}", month["#{mes}"])
      mensagem = "O Pedido #{numero_pedido} foi APROVADO na Data #{data}".upcase
      @b.textarea(name: "order_note"). set mensagem
      @b.send_keys [:shift, :enter]
      @b.send_keys [:shift, :enter]
      @b.send_keys "#{nome},"
      @b.send_keys [:shift, :enter]
      @b.send_keys "#{mensagem_email}"
      sleep 1
      @b.select_list(name: 'order_note_type').select 'Nota para o cliente'
      sleep 1
      @b.link(text: "Adicionar").click
      sleep 3
      @b.textarea(name: "order_note"). set "Email Enviado!"
      sleep 2
      @b.select_list(name: 'order_note_type').select 'Nota privada'
      sleep 1
      @b.link(text: "Adicionar").click
      sleep 2
      @b.send_keys :home
      sleep 2
      @b.button(text: "Salvar Pedido").click
      sleep 6
    end
  rescue
  end
end
@b.close
p "Terminei"
