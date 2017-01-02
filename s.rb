require 'watir-webdriver'

b = Watir::Browser.new :phantomjs
b.goto "http://instagram.com/accounts/login"

sleep 7
body = b.body
p body
body.text_fields.each do |text_field|
	p text_field.name
end

if b.url.include? "accounts/login"
	sleep 4
	p "If"
  b.text_fields[0].set 'capsluuk'
  b.text_fields[1].set 'analima'
	sleep 2
  b.button(:value => 'Submit').click
  sleep 7
end
p b.url
