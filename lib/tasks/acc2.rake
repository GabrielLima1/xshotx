prefs = {
    :profile => {
        :managed_default_content_settings => {
          :images => 2
        }
    }
}
#encoding: utf-8
require 'watir-webdriver'
require 'phantomjs'
namespace :acc2 do
  desc "Count message of Accounts"
  task app: :environment do
	p Account.all.length
    Account.find_each do |conta|
      if conta.status_message == true
      	begin
          @b = Watir::Browser.new :phantomjs, :prefs => prefs
          Watir.default_timeout = 90
          @b.window.maximize
  	    	p "Vou fazer a conta: ##{conta.id}"
  	    	#p @accounts
  	    	#breaka
    		  @b.goto "https://www3.olx.com.br/account/do_logout"
    			@b.text_field(id: 'login_email').set "#{conta.email}" #preencher
    			@b.text_field(id: 'login_password').set "#{conta.password}" #preencher
    			@b.button(type: 'submit').click
    			sleep 1
    			if @b.link(text: "Minha conta").present?
    				p "Bugada!"
            #conta.destroy
            @b.close
    			else#else conta Bugada
    				@b.goto "https://www3.olx.com.br/account/chat/"
    				sleep 2
    				mensagens = @b.divs(class: "chat-info-box").length
    				p "#{conta.email} mandou #{mensagens} Mensagens"
            sleep 5
      			while mensagens > 0
              begin
        				if @b.div(class: "chat-options").present? #div present
        					@b.div(class: "chat-options").hover
        					@b.link(text: "Excluir").click
        					sleep 1
        					@b.button(text: "Sim").click
        					sleep 1
        					@b.link(text: "Fechar").click
        					sleep 2
        					mensagens -= 1
                  p "-1 Mensagem"
        				else #div present
        					p "Tentando novamente!"
        					@b.goto "https://www3.olx.com.br/account/chat/"
        					sleep 3
        				end #div present
              rescue
                @b.close
                sleep 2
                "Travadinha de leve"
                @b = Watir::Browser.new :phantomjs, :prefs => prefs
                Watir.default_timeout = 90
                @b.window.maximize
                sleep 2
                @b.goto "https://www3.olx.com.br/account/do_logout"
          			@b.text_field(id: 'login_email').set "#{conta.email}" #preencher
          			@b.text_field(id: 'login_password').set "#{conta.password}" #preencher
          			@b.button(type: 'submit').click
                sleep 2
                @b.goto "https://www3.olx.com.br/account/chat/"
              end
      			end#end do while mensagens =D
            conta.status_message = false
            conta.save
    			end#end do else conta Bugada
      	rescue Net::ReadTimeout
      		p "Pulando Conta"
      		@b = Watir::Browser.new :phantomjs, :prefs => prefs
  			  Watir.default_timeout = 90
  			  @b.window.maximize
      	end
      end #end if status_message =D
    end
	@b.close
	p Account.all.length
	p "Fim - Acc2"
  end
end
