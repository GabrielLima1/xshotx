desc "HAHAHAHAHAHAH"
task :scheduler => :environment do
  puts "Atualizando Robôs..."
  Robot.find_each do |robot|
    if robot.status == true
      if robot.automatic == true
        if robot.status == true
          robot.status = false
          robot.save
        end
      end
    end
  end
  puts "Fim Atualização."
end
