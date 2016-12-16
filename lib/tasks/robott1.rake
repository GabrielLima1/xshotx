namespace :robott1 do
  desc "Fazendo os robo e tal"
  task app: :environment do
    robots = Robot.where(status: false) || []
    robots.each do |robot| #robot laço
      p robot.name
      if robot.page_number == 0 #else robot.page_number
        robot.page_number = robot.page_start
        robot.save
      end #end else robot.page_number
      num_G = robot.page_number
      num_P = robot.page_finish
      num_P-=1
      while num_P < num_G
        p "Vou fazer a Página1: #{robot.page_number}"
        Rake::Task['robott2:app'].execute
        sleep 10 # aumentar sleep depoisss
        num_G -= 1
        robot.page_number = num_G
        robot.save
      end
      sleep 2
      p "Saii"
      robot.status = true
      robot.save
    end #end robot laço
  end
end
