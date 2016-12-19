desc "HAHAHAHAHAHAH"
task :scheduler => :environment do
  puts "Atualizando Robôs..."
  Robot.find_each do |robot|
    if robot.automatic && robot.status
      robot.status = false
      robot.save
    end
  end
  puts "Fim Atualização."
end
