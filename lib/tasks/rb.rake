namespace :manda do
  desc "Fazendo os robo e tal"
  task :vai_robot => [:vai_pt2] do
    robots = Robot.where(status: false) || []
    robots.each do |robot| #robot laço
      if robot.page_number == 0 #else robot.page_number
        robot.page_number = robot.page_start
        robot.save
      end #end else robot.page_number
      num_G = robot.page_number
      num_P = robot.page_finish
      num_P-=1
      while num_P < num_G
        Rake::Task['manda:vai_pt2'].execute
        sleep 10 # aumentar sleep depoisss
        num_G -= 1
      end
      sleep 2
      p "Saii"
      robot.page_number = 0
      robot.status = true
      robot.save
    end #end robot laço
  end

  task vai_pt2: :environment do
    robots = Robot.where(status: false)where.not(name: "Robo de Compro") || []
    robots.each do |robot| #robot laço
      p robot.name
      if robot.page_number == 0 #else robot.page_number
        robot.page_number = robot.page_start
        robot.save
      end #end else robot.page_number
      pagina = robot.page_number
      p "Vou fazer a Página2: #{pagina} do #{robot.name}"
    end #end robot laço
  end
end
