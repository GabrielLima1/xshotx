require 'watir-webdriver'
b = Watir::Browser.new :phantomjs
b.goto "http://instagram.com/accounts/login"

if b.url.include? "accounts/login"
  b.text_field(name: "username").set "capsluuk"
  b.text_field(name: "password").set "analima"
  b.button(text: "Entrar").click
  sleep 7
end
p b.url
