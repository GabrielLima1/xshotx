require 'watir-webdriver'

b = Watir::Browser.new :phantomjs
b.window.resize_to(800, 600)
b.goto "http://instagram.com/accounts/login"
sleep(5)
p b.text_field(placeholder: "Username").present?
p b.text_field(placeholder: "Password").present?
p b.text_field(placeholder: "Username").exists?
p b.text_field(placeholder: "Password").exists?
