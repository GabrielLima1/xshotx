prefs = {
    :profile => {
        :managed_default_content_settings => {
          :images => 2
        }
    }
}
#encoding: utf-8
namespace :robot do
  desc "Run Robot Send Message"
  task app: :environment do
	@b = Watir::Browser.new :chrome, :prefs => prefs
	Watir.default_timeout = 90
	@b.window.maximize
	@agent = Mechanize.new
	if Account.all.length == 0
		p "Sem contas para fazer o Robo"
	else
    Robot.find_each do |robot|
      	if robot.name == "Robo Teste"
      		p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM1"
        		p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM2"
            p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM3"
            p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM4"
            p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM5"
            p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM6"
            p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM7"
            p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM8"
            p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM9"
            p "Robot: ##{robot.name} Não!"
        elsif robot.name == "Robo MM10"
            p "Robot: ##{robot.name} Não!"
      	else
          if robot.status == true
            p "Robot: ##{robot.name} Já Feito!"
            robot.page_number = 0
            robot.save
          else
            if robot.page_number == 0
              robot.page_number = robot.page_start
              robot.save
            end
            robot.search.rstrip!
            if robot.nosearch == ""
              nao = ""
            else
              nao = robot.nosearch.gsub(",","+NÃO").gsub(" ","+").gsub("  ","+").insert(0, 'NÃO+')
            end
            @info = Information.find_by_robot_id(robot.id)
            @log = RobotLog.find_by_robot_id(robot.id)
            while robot.status == false
              #break
              begin
                num_P = robot.page_finish
                num_P-=1
                num_G = robot.page_number
                id = Account.first.id
                while num_P < num_G
                  p "Vou fazer o ##{robot.name}"
                  conta = Account.find(id)
                  while conta.status_message == true
                    id += 1
                    conta = Account.find(id)
                    p "Pulando #{conta.email}"
                  end
                  @b.goto "https://www3.olx.com.br/account/do_logout"
                  @b.text_field(id: 'login_email').set conta.email #preencher
                  @b.text_field(id: 'login_password').set conta.password#preencher
                  @b.button(type: 'submit').click
                  sleep 1
                  if @b.link(text: "Minha conta").present?
                    p "Bugada!"
                    conta.destroy
                    num_G += 1
                  else
                    @b.goto "https://www3.olx.com.br/account/chat/"
                    sleep 1
                    mensagens = @b.divs(class: "chat-info-box").length
                    p "#{conta.email} mandou #{mensagens} Mensagens"
                    if mensagens > 250
                      p "Ops! #{conta.email} mandou #{mensagens} Mensagens"
                      conta.status_message = true
                      conta.save
                      num_G += 1
                    else
                      p "Chat Verificado!"
                      page = @agent.get("http://www.olx.com.br/brasil?o=#{num_G}&ot=1&q=#{robot.search}+#{nao}")
                      sleep 2
                      page.links_with(:dom_class => "OLXad-list-link").each do |link|
                        begin
                          @b.goto link.href
                          sleep 2
                          usuario = @b.li(class: "item owner mb10px ").text
                          divs = @b.div(class: "OLXad-location mb20px")
                          cep = divs.strong(:index, 1).text
                          ceps = @info.cep.split("|")
                          usuarios = @info.usuario.split("|")
                          if @b.link(text: "Minha conta").visible?
                            sleep 1
                            @b.goto "https://www3.olx.com.br/account/do_logout"
                            @b.text_field(id: 'login_email').set conta.email #preencher
                            @b.text_field(id: 'login_password').set conta.password #preencher
                            @b.button(type: 'submit').click
                            sleep 1
                            @b.goto link.href
                            sleep 2
                          end
                          sleep 1
                          if ceps.include? cep
                            if usuarios.include? usuario
                              p "Pulando Já Feito!"
                              @log.pulados += 1
                              @log.save
                            else
                              #salve somente o usuario
                              @b.button(text: "Iniciar chat").click
                              sleep 1
                              if @b.p(text: "Esse usuário não pode mais receber mensagens.").present?
                                p "Pulando"
                                @log.pulados += 1
                                @log.save
                              elsif @b.li(class: "item-message ng-scope").present?
                                p "Pulando Já Feito!"
                                @log.pulados += 1
                                @log.save
                              else
                                @info.usuario = @info.usuario+"|#{usuario}"
                                @info.save
                                @b.textarea(name: 'message').when_present.set robot.type.message #preencher
                                @b.button(text: "Enviar").click
                                sleep 1
                                p "Feito"
                                @log.done_chat += 1
                                @log.save
                              end
                            end
                          else
                            @b.button(text: "Iniciar chat").click
                            sleep 1
                            if @b.p(text: "Esse usuário não pode mais receber mensagens.").present?
                              p "Pulando"
                              @log.pulados += 1
                              @log.save
                            elsif @b.li(class: "item-message ng-scope").present?
                              p "Pulando Já Feito!"
                              @log.pulados += 1
                              @log.save
                            else
                              @info.cep = @info.cep+"|#{cep}"
                              @info.usuario = @info.usuario+"|#{usuario}"
                              @info.save
                              @b.textarea(name: 'message').when_present.set robot.type.message #preencher
                              @b.button(text: "Enviar").click
                              sleep 1
                              p "Feito"
                              @log.done_chat += 1
                              @log.save
                            end
                          end #end do minha conta visible
                        rescue
                          #Mechanize::ResponseCodeError
                          p "Falha ao entrar no Link do Anuncio..."
                          @log.fail_chat += 1
                          @log.save
                        end#end do chat
                      end #end do each do mechanize PAGE
                    end #else chat verificado
                  end
                  hora = Time.now
                  hora -= 7200
                  @log.message = "Fiz a Pagina #{robot.page_number} da Palavra: #{robot.search} - Data: #{hora}"
                  p "Fiz a Pagina #{robot.page_number} e usei a Conta #{conta.email} da Palavra: #{robot.search}"
                  num_G -= 1
                  robot.page_number = num_G
                  robot.save
                  @log.save
                  @b.close
                  sleep 2
                  @b = Watir::Browser.new :chrome, :prefs => prefs
                  Watir.default_timeout = 90
                  @b.window.maximize
                end#end do while num_P e num_G
                robot.status = true
                robot.page_number = 0
                robot.save
                hora = Time.now
                hora -= 7200
                @log.message = "#{robot.name} Feito da Pagina: #{robot.page_finish} até #{robot.page_start}, Data: #{hora}"
                @log.save
              rescue Net::ReadTimeout
                @b.close
                sleep 2
                @b = Watir::Browser.new :chrome, :prefs => prefs
                Watir.default_timeout = 90
                @b.window.maximize
                p "Time"
              end
            end #end do while robot.status
          end#end do else do status robot
  		  end #else dos robot.name
    end #end do robot_each
	end # end do account.all verificação se a contas disponivel
	@b.close
	p "Fim Robot"
  p "...Iniciando Scheduler"
  Rake::Task['scheduler'].execute
  end
end
