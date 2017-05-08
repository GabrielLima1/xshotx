#encoding: utf-8
namespace :robott do
  desc "Run Robot Send Message"
  task send: :environment do
    if Account.all.length == 0
      p "Sem contas para fazer o Robo"
    else
      robots = Robot.where(status: false).where(name: ["Robo de Compro","Robo de Procuro","Robo de Compramos","Robo de Quero Comprar"]) || []
      robots.find_each do |robot| # robot laço
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
        @log.message = "Exec"
        while robot.status == false
          #break
          num_P = robot.page_finish
          num_P-=1
          num_G = robot.page_number

          while num_P < num_G

            conta = Account.where(status_message: false).first

            @b = Watir::Browser.new :phantomjs
            Watir.default_timeout = 60
            @b.window.maximize
            @agent = Mechanize.new
            sleep 2
            @b.goto "https://www3.olx.com.br/account/do_logout"
            @b.text_field(id: 'login_email').set conta.email #preencher
            @b.text_field(id: 'login_password').set conta.password#preencher
            @b.button(type: 'submit').click
            sleep 1
            if @b.div(id: "container_not_logged").present?
              p "Bugada!"
              #conta.destroy
              conta.status_message = true
              conta.save
              num_G += 1
            else
              @b.goto "https://www3.olx.com.br/account/chat/"
              sleep 1
              mensagens = @b.divs(class: "chat-info-box").length
              p "#{conta.email} mandou #{mensagens} Mensagens"
              mensagens += 50
              if mensagens > 251
                p "Ops! #{conta.email} mandou #{mensagens} Mensagens"
                conta.status_message = true
                conta.save
                num_G += 1
              else
                p "Chat Verificado!"
                page = @agent.get("http://www.olx.com.br/brasil?o=#{robot.page_number}&ot=1&q=#{robot.search}+#{nao}")
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

                    if @b.div(id: "container_not_logged").present?
                      @b.goto "https://www3.olx.com.br/account/do_logout"
                      @b.text_field(id: 'login_email').set conta.email #preencher
                      @b.text_field(id: 'login_password').set conta.password #preencher
                      @b.button(type: 'submit').click
                      sleep 1
                      @b.goto link.href
                      sleep 2
                    end

                    sleep 1
                    if (ceps.include?cep) && (usuarios.include?usuario)
                      p "Pulando Já Feito!"
                      @log.pulados += 1
                      @log.save
                    else
                      sleep 3
                      @b.button(class: "btn btn-large btn-start-chat btn-orange").click
                      sleep 2
                      while @b.span(class: "wss-text").present?
                        sleep 1
                      end
                      if @b.li(class: "item-message ng-scope").present?
                        p "Pulando Já Feito!"
                        @log.pulados += 1
                        @log.save
                      else
                        @b.textarea(name: 'message').set robot.type.message #preencher
                        sleep 1
                        @b.button(text: "Enviar").click
                        p "Feito"
                        @info.cep = @info.cep+"|#{cep}"
                        @info.usuario = @info.usuario+"|#{usuario}"
                        @log.done_chat += 1
                        @info.save
                        @log.save
                      end
                    end #end do minha conta visible
                  rescue Net::ReadTimeout => e
                    p "Timeout"
                    @log.fail_chat += 1
                    @log.save
                  rescue
                    #Mechanize::ResponseCodeError
                    p "Falha ao entrar no Link do Anuncio..."
                    @log.fail_chat += 1
                    @log.save
                    next
                  end#end rescue
                end #end do each do mechanize PAGE
              end #else chat verificado
              hora = Time.now
              hora -= 7200
              @log.message = "Fiz a Pagina #{robot.page_number} da Palavra: #{robot.search} - Data: #{hora}"
              p "Fiz a Pagina #{robot.page_number} e usei a Conta #{conta.email} da Palavra: #{robot.search}"
              num_G -= 1
              robot.page_number = num_G
              robot.save
              @log.save
              @b.close
            end #end do else status_message
          end#end do while num_P e num_G
          robot.status = true
          robot.page_number = 0
          robot.save
          hora = Time.now
          hora -= 7200
          @log.message = "#{robot.name} Feito da Pagina: #{robot.page_finish} até #{robot.page_start}, Data: #{hora}"
          @log.save
        end #end do while robot.status
      end #end do robot_each
    end # end do account.all verificação se a contas disponivel
    @b.close
    p "Fim Robot"
    p "...Iniciando Scheduler"
    Rake::Task['scheduler'].execute
  end
end
