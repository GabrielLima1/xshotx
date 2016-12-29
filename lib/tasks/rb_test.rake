namespace :teste_robot do
  desc "Fazendo os robo e tal"
  task vai_robot: :environment do
    robots = Robot.where(status: false).where.not(name: ["Robo de Teste","Robo MM1","Robo MM2","Robo MM3","Robo MM4","Robo MM5","Robo MM6","Robo MM7","Robo MM8","Robo MM9","Robo MM10"]) || []
    robot = robots.first # robot laço
    if robot.page_number == 0 # if robot.page_number
      robot.page_number = robot.page_start
      robot.save
    end # end robot.page_number
    num_G = robot.page_number
    num_P = robot.page_finish
    num_P-=1
    numero = 0
    while num_P < num_G # while num_P | num_G
      if numero < 2
        if robot.page_number == num_P
          robot.page_number = 0
          robot.status = true
          robot.save
          hora = Time.now
          hora -= 7200
          @log = RobotLog.find_by_robot_id(robot.id)
          @log.message = "#{robot.name} Feito da Pagina: #{robot.page_finish} até #{robot.page_start}, Data: #{hora}"
          @log.save
          break
        else
          p "Executei o Job"
          SendRobotJob.perform_later robot
          p "----------------------------------------"
          sleep 20
          num_G -= 1
          numero += 1
          robot.page_number = num_G
          robot.save
          p "oi"
        end
      else
        break
      end
    end # end num_P | num_G
    sleep 2
    p "Sai do While"
    p "page_number = #{robot.page_number}"
    p "Sleeppp"
    sleep 580
  end

  # task vai_pt2: :environment do # taks parte 2
  #   robots = Robot.where(status: false).where.not(name: ["Robo de Compro","Robo de Procuro","Robo de Compramos","Robo de Compramos"]) || []
  #   robots.each do |robot| #robot laço
  #     p "Fazendo o Robot Tal"
  #     robot.page_number -= 1
  #     robot.save
  #   end # end vericação de mensagens
  # end # end taks parte 2
end
