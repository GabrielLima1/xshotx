require 'watir-webdriver'
b = Watir::Browser.new :phantomjs
b.driver.manage.timeouts.implicit_wait = 3 #3 seconds
b.goto "http://instagram.com/accounts/login"
sleep 7
body = b.body
body.text_fields.each do |text_field|
	p text_field.name
end

if b.url.include? "accounts/login"
	sleep 4

  b.text_field(:name => /username/).set 'capsluuk'
  b.text_field(:name => /password/).set 'analima'
  b.button(:value => 'Submit').click
  sleep 7
end
p b.url
