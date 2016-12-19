prefs = {
    :profile => {
        :managed_default_content_settings => {
          :images => 2
        }
    }
}
#encoding: utf-8
namespace :manda do
  desc "Fazendo os robo e tal"
  task :vai_robot => [:vai_pt2] do
    robots = Robot.where(status: false).where.not(name: ["Robo de Compro","Robo de Procuro","Robo de Compramos","Robo de Compramos"]) || []
    robots.each do |robot| # robot laço
      if robot.page_number == 0 # if robot.page_number
        robot.page_number = robot.page_start
        robot.save
      end # end robot.page_number
      num_G = robot.page_number
      num_P = robot.page_finish
      num_P-=1
      while num_P < num_G # while num_P | num_G
        Rake::Task['manda:vai_pt2'].execute
        p "----------------------------------------"
        num_G -= 1
        robot.page_number = num_G
        robot.save
      end # end num_P | num_G
      sleep 2
      p "Saii"
      robot.page_number = 0
      robot.status = true
      robot.save
    end # end robot laço
  end

  task vai_pt2: :environment do
    robots = Robot.where(status: false).where.not(name: ["Robo de Compro","Robo de Procuro","Robo de Compramos","Robo de Compramos"]) || []
    robots.each do |robot| #robot laço

      if robot.page_number == 0 #else robot.page_number
        robot.page_number = robot.page_start
        robot.save
      end #end else robot.page_number

      pagina = robot.page_number
      @b = Watir::Browser.new :chrome, :prefs => prefs
    	Watir.default_timeout = 90
    	@b.window.maximize
    	@agent = Mechanize.new

      #iniciando login
      conta = Account.where(status_message: false).first
      @b.goto "https://www3.olx.com.br/account/do_logout"
      @b.text_field(id: 'login_email').set conta.email #preencher
      @b.text_field(id: 'login_password').set conta.password#preencher
      @b.button(type: 'submit').click
      sleep 1
      #fim login

      #inicio verificação mensagens
      @b.goto "https://www3.olx.com.br/account/chat/"
      sleep 1
      mensagens = @b.divs(class: "chat-info-box").length
      p "#{conta.email} mandou #{mensagens} Mensagens"

      if mensagens > 243
        p "Ops! #{conta.email} mandou #{mensagens} Mensagens"
        conta.status_message = true
        conta.save
      else # else da vericação de mensagens
        @info = Information.find(1)
        @log = RobotLog.find_by_robot_id(robot.id)
        p "Chat Verificado!"
        p "Vou fazer a Página: #{pagina} do #{robot.name}"

        page = @agent.get("http://www.olx.com.br/brasil?o=#{pagina}")
        sleep 2
        page.links_with(:dom_class => "OLXad-list-link").each do |link|
          begin
            @b.goto link.href
            sleep 2

            #pegando dados do usuario
            usuario = @b.li(class: "item owner mb10px ").text
            divs = @b.div(class: "OLXad-location mb20px")
            cep = divs.strong(:index, 1).text
            ceps = @info.cep.split("|")
            usuarios = @info.usuario.split("|")

            if @b.link(text: "Minha conta").visible? # if minha conta
              sleep 1
              @b.goto "https://www3.olx.com.br/account/do_logout"
              @b.text_field(id: 'login_email').set conta.email # preencher
              @b.text_field(id: 'login_password').set conta.password # preencher
              @b.button(type: 'submit').click
              sleep 1
              @b.goto link.href
              sleep 2
            end #end minha conta

            if ceps.include? cep # if cep | usuario
              if usuarios.include? usuario # if | usuario |
                p "Pulando!"
                @log.pulados += 1
                @log.save
              else # else | usuario |
                # salvando somente o usuario
                @b.button(text: "Iniciar chat").click
                sleep 1
                if @b.p(text: "Esse usuário não pode mais receber mensagens.").present? # if bang chat pt1
                  p "Pulando!"
                  @log.pulados += 1
                  @log.save
                elsif @b.li(class: "item-message ng-scope").present? # elsif bang chat pt1
                  p "Pulando Já Feito!"
                  @log.pulados += 1
                  @log.save
                else #else bang chat pt1
                  @info.usuario = @info.usuario+"|#{usuario}"
                  @info.save
                  @b.textarea(name: 'message').when_present.set robot.type.message # preencher
                  @b.button(text: "Enviar").click
                  sleep 1
                  p "Feito"
                  @log.done_chat += 1
                  @log.save
                end # end bang chat pt1
              end # end | usuario |

            else # else cep | usuario
              @b.button(text: "Iniciar chat").click
              sleep 1
              if @b.p(text: "Esse usuário não pode mais receber mensagens.").present? # if bang chat pt2
                p "Pulando!"
                @log.pulados += 1
                @log.save
              elsif @b.li(class: "item-message ng-scope").present? # elsif bang chat pt2
                p "Pulando Já Feito!"
                @log.pulados += 1
                @log.save
              else # else bang chat pt2
                @info.cep = @info.cep+"|#{cep}"
                @info.usuario = @info.usuario+"|#{usuario}"
                @info.save
                @b.textarea(name: 'message').when_present.set robot.type.message #preencher
                @b.button(text: "Enviar").click
                sleep 1
                p "Feito"
                @log.done_chat += 1
                @log.save
              end # end bang chat pt2
            end # end cep | usuario
          rescue
            #Mechanize::ResponseCodeError
            p "Falha ao entrar no Link do Anuncio..."
            @log.fail_chat += 1
            @log.save
          end# end do chat
        end # end do each do mechanize PAGE
        robot.page_number -= 1
        robot.save
      end # end vericação de mensagens
      # fim verificação mensagens
      @b.close
    end # end robot laço
  end
end
