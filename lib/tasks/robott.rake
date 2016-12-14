prefs = {
    :profile => {
        :managed_default_content_settings => {
          :images => 2
        }
    }
}
#encoding: utf-8
namespace :robott do
  desc "Run Robot Send Message"
  task app: :environment do
	@b = Watir::Browser.new :phantomjs, :prefs => prefs
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
                    if conta == nil
                      id += 1
                    end
                    p "Pulando #{conta.email}"
                  end
                end
              rescue Net::ReadTimeout
                @b.close
                sleep 2
                @b = Watir::Browser.new :phantomjs, :prefs => prefs
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
