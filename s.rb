require 'watir-webdriver'

b = Watir::Browser.new :phantomjs

b.goto "https://www.instagram.com/accounts/login/?hl=pt-br"

sleep 4
b.text_fields(class: "_qy55y")[0].set "capsluuk"
b.text_fields(class: "_qy55y")[1].set "analima"
b.button(text: "Log in").click
sleep 7
p b.url
