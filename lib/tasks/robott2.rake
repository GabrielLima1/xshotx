namespace :teste_robot do
  desc "Fazendo os robo e tal"
  task vai_robot: :environment do
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
        SendRobotJob.perform_later robot
        p "Executei o Job"
        p "----------------------------------------"
        sleep 40
        num_G -= 1
        robot.page_number = num_G
        robot.save
      end # end num_P | num_G
      sleep 2
      p "Sai do While"
      robot.page_number = 0
      robot.status = true
      robot.save
    end # end robot laço
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
