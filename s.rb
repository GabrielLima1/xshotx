require 'watir-webdriver'

b = Watir::Browser.new :phantomjs

b.goto "https://www.instagram.com/accounts/login/?hl=pt-br"

sleep 7
body = b.body
p body
body.text_fields.each do |text_field|
	p text_field.name
end

if b.url.include? "accounts/login"
  b.text_field(name: "username").set "capsluuk"
  b.text_field(name: "password").set "analima"
  b.button(text: "Entrar").click
  sleep 7
end
p b.url
