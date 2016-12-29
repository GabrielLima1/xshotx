class SendRobotJob < ApplicationJob # CLASS
  queue_as :default

  def perform(robot) # DEF PERFORM
    pagina = robot.page_number
    #!/usr/bin/ruby
    #encoding: utf-8
    prefs = {
      :profile => {
        :managed_default_content_settings => {
          :images => 2
        }
      }
    }
    require 'watir-webdriver'
    require 'phantomjs'
    require 'mechanize'

    @conta = Account.where(status_message: false).first
    @b = Watir::Browser.new :phantomjs, :prefs => prefs
    Watir.default_timeout = 90
    @b.window.maximize
    @agent = Mechanize.new

     # inicio LOGIN
     @b.goto "https://www3.olx.com.br/account/do_logout"
     @b.text_field(id: 'login_email').set @conta.email #preencher
     @b.text_field(id: 'login_password').set @conta.password#preencher
     @b.button(type: 'submit').click
     sleep 1
     # fim LOGIN

     # inicio verificação chat
     @b.goto "https://www3.olx.com.br/account/chat/"
     sleep 1
     mensagens = @b.divs(class: "chat-info-box").length
     p "#{@conta.email} mandou #{mensagens} Mensagens"

     mensagens += 50
     if mensagens > 251 # if mensagens
       p "Ops! #{@conta.email} mandou #{mensagens} Mensagens"
       @conta.status_message = true
       @conta.save
       # MANDAR RODAR UM JOB PARA APAGAR AS MENSAGENS DA CONTA
     else # else mensagens
       robot.search.rstrip!
       if robot.nosearch == ""
         nao = ""
       else
         nao = robot.nosearch.gsub(",","+NÃO").gsub(" ","+").gsub("  ","+").insert(0, 'NÃO+')
       end

       @info = Information.find_by_robot_id(robot.id)
       @log = RobotLog.find_by_robot_id(robot.id)
       p "Chat Verificado!"
       p "Vou fazer a Página: #{pagina} do #{robot.name}"
      #  begin # BEGIN TIMEOUT
       # inicio DO Mechanize
       page = @agent.get("http://www.olx.com.br/brasil?o=#{pagina}&ot=1&q=#{robot.search}+#{nao}")
       sleep 2
       page.links_with(:dom_class => "OLXad-list-link").each do |link|
        #  begin # BEGIN | RESCUE
         @b.goto link.href
         sleep 2

         # inicio dados do usuario
         usuario = @b.li(class: "item owner mb10px ").text
         divs = @b.div(class: "OLXad-location mb20px")
         cep = divs.strong(:index, 1).text
         ceps = @info.cep.split("|")
         usuarios = @info.usuario.split("|")
         # fim dados do usuario

         if @b.link(text: "Minha conta").visible? # if minha conta
           sleep 1
           @b.goto "https://www3.olx.com.br/account/do_logout"
           @b.text_field(id: 'login_email').set @conta.email # preencher
           @b.text_field(id: 'login_password').set @conta.password # preencher
           @b.button(type: 'submit').click
           sleep 1
           @b.goto link.href
           sleep 2
         end #end minha conta

         if ceps.include? cep # if cep | usuario
           if usuarios.include? usuario # if | usuario |
             p "Pulando#{pagina}!, #{robot.name}!"
             @log.pulados += 1
             @log.save
           else # else | usuario |
             # salvando somente o usuario
             @b.button(text: "Iniciar chat").click
             sleep 1
             if @b.p(text: "Esse usuário não pode mais receber mensagens.").present? # if bang chat pt1
               p "Pulando#{pagina}, #{robot.name}!"
               @log.pulados += 1
               @log.save
             elsif @b.li(class: "item-message ng-scope").present? # elsif bang chat pt1
               p "Pulando Já Feito#{pagina}, #{robot.name}!"
               @log.pulados += 1
               @log.save
             else #else bang chat pt1
               @info.usuario = @info.usuario+"|#{usuario}"
               @info.save
               @b.textarea(name: 'message').when_present.set robot.type.message # preencher
               @b.button(text: "Enviar").click
               sleep 1
               p "Feito#{pagina}, #{robot.name}"
               @log.done_chat += 1
               @log.save
             end # end bang chat pt1
           end # end | usuario |
         else # else cep | usuario
           @b.button(text: "Iniciar chat").click
           sleep 1
           if @b.p(text: "Esse usuário não pode mais receber mensagens.").present? # if bang chat pt2
             p "Pulando#{pagina}, #{robot.name}!"
             @log.pulados += 1
             @log.save
           elsif @b.li(class: "item-message ng-scope").present? # elsif bang chat pt2
             p "Pulando Já Feito#{pagina}, #{robot.name}!"
             @log.pulados += 1
             @log.save
           else # else bang chat pt2
             @info.cep = @info.cep+"|#{cep}"
             @info.usuario = @info.usuario+"|#{usuario}"
             @info.save
             @b.textarea(name: 'message').when_present.set robot.type.message #preencher
             @b.button(text: "Enviar").click
             sleep 1
             p "Feito#{pagina}, #{robot.name}"
             @log.done_chat += 1
             @log.save
           end # end bang chat pt2
         end # end cep | usuario
        #  rescue # BEGIN | RESCUE
        #    #Mechanize::ResponseCodeError
        #    p "Falha ao entrar no Link do Anuncio... #{pagina}, #{robot.name}"
        #    @log.fail_chat += 1
        #    @log.save
        #  end# end BEGIN | RESCUE
       end # end do each do mechanize PAGE
     end # end if | esle  mensagens
     @b.close
  end # END DEF PERFORM
end # END CLASS
