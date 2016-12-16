namespace :robott2 do
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
      p "Vou fazer a Página2: #{num_G}"
      robot.status = true
      robot.save
    end #end robot laço
  end
end
