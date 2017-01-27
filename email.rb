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
mensagem = "Status do pedido alterado de Processando para Aguardando."

login_wpp = "admin"
senha_wpp = "alma1505@12#12"
numero = 1
ok = 0
erro = 0
# FAZENDO LOGIN NO WPP
@b = Watir::Browser.new :chrome
Watir.default_timeout = 90
@b.window.maximize

@b.goto "http://mistermattpulseiras.com.br/wp-login.php"
@b.text_field(name: "log").set login_wpp
@b.text_field(name: "pwd").set senha_wpp
@b.button(type: "submit").click
sleep 2
p "Login no WPP Feito"
#http://mistermattpulseiras.com.br/wp-admin/edit.php?s&post_status=wc-processing&post_type=shop_order&action=-1&m=201701&_customer_user&filter_action=Filtrar&paged=1&action2=-1

@b.goto "http://mistermattpulseiras.com.br/wp-admin/edit.php?post_status=wc-on-hold&post_type=shop_order&paged=#{numero}"
sleep 2
p final = @b.span(class: "total-pages").text
final = 3

while numero <= final
  begin
    @b.goto "http://mistermattpulseiras.com.br/wp-admin/edit.php?post_status=wc-on-hold&post_type=shop_order&paged=#{numero}"
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
    div = @b.div(id: "order_data")
    numero_pedido = div.h2s.first.text.gsub("Detalhes do Pedido ", "")
    if @b.p(text: "Email Enviado!").present? && @b.p(text: "#{mensagem}").present?
      ok += 1
    elsif @b.p(text: "#{mensagem}").present?
      p "Erro - #{numero_pedido}"
      erro += 1
      @b.textarea(name: "order_note").set "Email Enviado!"
      sleep 2
      @b.link(text: "Adicionar").click
      sleep 2
    end
  rescue
    p "Erro #{link}"
  end
end
@b.close
p "Terminei"
p "Ok: #{ok} / Erro: #{erro}"
