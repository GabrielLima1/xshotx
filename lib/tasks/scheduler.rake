desc "HAHAHAHAHAHAH"
task :scheduler => :environment do
  puts "Atualizando Robôs..."
  Robot.find_each do |robot|
    if robot.automatic && robot.status
      robot.status = false
      robot.page_number = 0
      robot.save
    end
  end
  puts "Fim Atualização."
end
