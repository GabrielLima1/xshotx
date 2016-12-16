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
require 'mechanize'
namespace :account do
  desc "Count message of Accounts"
  task app: :environment do
	p Account.all.length
    Account.find_each do |conta|
      if conta.status == true || conta.status_message == true
        p "##{conta.id} Feito!"
      else
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
            conta.destroy
            @b.close
    			else
    				@b.goto "https://www3.olx.com.br/account/chat/"
    				sleep 2
    				mensagens = @b.divs(class: "chat-info-box").length
    				p "#{conta.email} mandou #{mensagens} Mensagens"
    				if mensagens > 250
    					p "Ops! #{conta.name} mandou #{mensagens} Mensagens"
    					conta.status_message = true
              conta.save
              @b.close
    				else
    					p "Chat Verificado!"
    					if @b.link(text: "#{conta.name}").present?
    						p "Name ok: #{conta.id}"
                conta.status = true
                conta.save
                @b.close
    					else
    						begin
    							@b.link(:text =>"Meu cadastro").when_present.click
    							sleep 1
    							@b.text_field(id: 'fullname').set "#{conta.name}"
    							@b.text_field(id: 'nickname').set "#{conta.name}"
    							sleep 1
                  @b.select_list(name: 'contact_type').select 'celular'
                  @b.text_field(id: 'phone').set "(11) 94654 1199"
    							@b.button(text: "Salvar").click
                  sleep 2
                  conta.status = true
                  conta.save
                  @b.close
    						rescue
    							p "Tentando mais uma vez"
    							@b.close
    							sleep 1
    							@b = Watir::Browser.new :phantomjs, :prefs => prefs
    							Watir.default_timeout = 90
    							@b.window.maximize
    						end#end rescue
    					end#end else
    				end#end else verificação chat
    			end#end do else conta Bugada
      	rescue Net::ReadTimeout
      		p "Pulando Conta"
      		@b = Watir::Browser.new :phantomjs, :prefs => prefs
  			  Watir.default_timeout = 90
  			  @b.window.maximize
      	end
      end
    end
	@b.close
	p Account.all.length
	p "Fim - Account"
  p "...Iniciando Acc1"
  Rake::Task['acc1:app'].execute
  end
end
