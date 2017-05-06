# Encoding: UTF-8
p "Robo Versão '1.0.1'"
require 'watir-webdriver'
require 'mechanize'
arquivo = File.new("Email.txt","w")
puts "Aguarde..."
login_wpp = "admin"
senha_wpp = "alma1505@12#12"


links = []
emails = []
numero = 1
antigos = 0
novos = 0
p "Aguarde..."

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

while  numero <= 51
  @b.goto "http://mistermattpulseiras.com.br/wp-admin/edit.php?post_status=wc-completed&post_type=shop_order&paged=#{numero}"
  sleep 3
  tds = @b.tds(class: "column-primary")
  tds.each do |td|
    link = td.small
    arquivo.puts link.text
  end
  numero += 1
end
arquivo.close
