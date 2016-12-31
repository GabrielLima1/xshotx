#encoding: utf-8
namespace :manda do
  desc "Fazendo os robo e tal"
  task :vai_robot => [:vai_pt2] do
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
        p "Executei a Task"
        task :execute => ['manda:vai_pt2']
        p "----------------------------------------"
        sleep 4
        num_G -= 1
        numero += 1
        robot.page_number = num_G
        robot.save
      else
        break
      end
    end # end num_P | num_G
    sleep 2
    p "Sai do While"
    p "page_number = #{robot.page_number}"
    if robot.page_number == 0
      robot.page_number = 0
      robot.status = true
      robot.save
    end
    p "Sleeppp"
    #sleep 580
  end

  task vai_pt2: :environment do
    robots = Robot.where(status: false).where.not(name: ["Robo de Teste","Robo MM1","Robo MM2","Robo MM3","Robo MM4","Robo MM5","Robo MM6","Robo MM7","Robo MM8","Robo MM9","Robo MM10"])
    p robot = robots.first || [] # robot laço
    p "Iniciando pt2..."
    #iniciando login
    p "Vou fazer o #{robot.name}, a pagina #{robot.page_number}"

  end
end
