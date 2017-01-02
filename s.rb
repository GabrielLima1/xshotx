require 'watir-webdriver'

b = Watir::Browser.new :phantomjs

b.goto "instagram.com"

body = b.body
body.text_fields.each do |text_field|
  p text_field.name
end
sleep 7
p b.url
