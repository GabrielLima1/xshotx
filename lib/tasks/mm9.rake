#encoding: utf-8
namespace :mm9 do
  desc "Run Robot Send Message"
  task app: :environment do
	@b = Watir::Browser.new :phantomjs
	Watir.default_timeout = 90
	@b.window.maximize
  sleep 2
  conta = Account.where(status_message: false).first
	@b.goto "https://www3.olx.com.br/account/do_logout"
  @b.text_field(id: 'login_email').set conta.email #preencher
  @b.text_field(id: 'login_password').set conta.password#preencher
  @b.button(type: 'submit').click
  sleep 2
  @b.goto "http://sp.olx.com.br/sao-paulo-e-regiao/bebes-e-criancas/roupa-usada-de-bebe-336297678"
  sleep 2
  @b.button(text: "Iniciar chat").click
  sleep 2
  @b.textarea(name: 'message').when_present.set "Teste Local!" #preencher
  @b.button(text: "Enviar").click
  sleep 2
  p "Feito"
	@b.close
	p "Fim"
  end
end
