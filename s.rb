require 'watir-webdriver'

b = Watir::Browser.new :phantomjs

b.goto "https://www.instagram.com/accounts/login/?hl=pt-br"

sleep 4
b.text_field(placeholder: "Nome de usuário").set "capsluuk"
b.text_field(placeholder: "Senha").set "analima"
b.button(text: "Entrar").click
sleep 7
p b.url
