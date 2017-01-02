require 'watir-webdriver'

b = Watir::Browser.new :phantomjs
b.window.resize_to(800, 600)
b.goto "http://instagram.com/accounts/login"
sleep(5)
puts b.iframe(:class => "hiFrame").text_field(:name => "username").exists?
b.iframe(:class => "hiFrame").text_field(:name => "username").set "capsluuk"
b.iframe(:class => "hiFrame").text_field(:name => "password").set "analima"
puts b.iframe(:class => "hiFrame").text_field(:name => "username").exists?
b.iframe(:class => "hiFrame").button.click
