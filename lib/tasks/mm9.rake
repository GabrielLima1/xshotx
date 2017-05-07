#encoding: utf-8
namespace :mm9 do
  desc "Run Robot Send Message"
  task app: :environment do
	@b = Watir::Browser.new :phantomjs
	Watir.default_timeout = 90
	@b.window.maximize
  sleep 2
  #conta = Account.where(status_message: false).first
	@b.goto "https://www3.olx.com.br/account/do_logout"
  @b.text_field(id: 'login_email').set "gabriellimatrajano@hotmail.com" #preencher
  @b.text_field(id: 'login_password').set "analima@123" #preencher
  @b.button(type: 'submit').click
  sleep 2
  @b.goto "http://sp.olx.com.br/sao-paulo-e-regiao/bebes-e-criancas/roupa-usada-de-bebe-336297678"
  sleep 2
  if @b.div(id: "container_not_logged").present?
    p "Bugada!"
  end
  sleep 3
  @b.button(class: "btn btn-large btn-start-chat btn-orange").click
  sleep 3
  @b.textarea(name: 'message').set "Teste Server!- Pt.2" #preencher
  sleep 3
  @b.button(text: "Enviar").click
  sleep 2
  p "Feito"
	@b.close
	p "Fim"
  end
end
