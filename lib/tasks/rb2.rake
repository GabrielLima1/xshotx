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
namespace :manda1 do
  task vai_pt2: :environment do
    robots = Robot.where(status: false).where.not(name: ["Robo de Teste","Robo MM1","Robo MM2","Robo MM3","Robo MM4","Robo MM5","Robo MM6","Robo MM7","Robo MM8","Robo MM9","Robo MM10"]) || []
    p robot = robots.first # robot laço
    p "Iniciando pt2..."
    #iniciando login

    pagina = robot.page_number

    @conta = Account.where(status_message: false).first
    @b = Watir::Browser.new :chrome, :prefs => prefs
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
         begin # BEGIN | RESCUE
           @b.goto link.href
         rescue
         end
       end
     end

  end
end
