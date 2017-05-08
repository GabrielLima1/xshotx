task compro: :environment do
  puts "start one"
  # robots = Robot.where(status: false).where(name: ["Robo de Compro"])
  # robots.find_each do |robot|
  #   if robot.page_number == 0
  #     robot.page_number = robot.page_start
  #     robot.save
  #   end
  #   robot.search.rstrip!
  #   if robot.nosearch == ""
  #     nao = ""
  #   else
  #     nao = robot.nosearch.gsub(",","+NÃO").gsub(" ","+").gsub("  ","+").insert(0, 'NÃO+')
  #   end
  #   @info = Information.find_by_robot_id(robot.id)
  #   @log = RobotLog.find_by_robot_id(robot.id)
  #   @log.message = "Executando Robô!"
  #   @log.save
  #
  #   num_P = robot.page_finish
  #   num_P-=1
  #   num_G = robot.page_number
  #   while num_P < num_G
  #
  #   end
  conta = Account.where(status_message: false).first

  @b = Watir::Browser.new :chrome
  Watir.default_timeout = 90
  @b.window.maximize
  @agent = Mechanize.new

  @b.goto "https://www3.olx.com.br/account/do_logout"
  sleep 3
  @b.text_field(id: 'login_email').set conta.email #preencher
  @b.text_field(id: 'login_password').set conta.password#preencher
  @b.button(type: 'submit').click
  sleep 1
  puts "one done"
end

task procuro: :environment do
  puts "start two"

  conta = Account.where(status_message: false).first

  @b = Watir::Browser.new :chrome
  Watir.default_timeout = 90
  @b.window.maximize
  @agent = Mechanize.new

  @b.goto "https://www3.olx.com.br/account/do_logout"
  sleep 3
  @b.text_field(id: 'login_email').set conta.email #preencher
  @b.text_field(id: 'login_password').set conta.password#preencher
  @b.button(type: 'submit').click
  sleep 1
  puts "two done"
end

task quero: :environment do
  puts "start three"

  conta = Account.where(status_message: false).first

  @b = Watir::Browser.new :chrome
  Watir.default_timeout = 90
  @b.window.maximize
  @agent = Mechanize.new

  @b.goto "https://www3.olx.com.br/account/do_logout"
  sleep 3
  @b.text_field(id: 'login_email').set conta.email #preencher
  @b.text_field(id: 'login_password').set conta.password#preencher
  @b.button(type: 'submit').click
  sleep 1
  puts "three done"
end

desc "Submit all feed to amazon for SITE"
task :do_all do
  threads = []
  %w{compro procuro quero}.each do |number|
    threads << Thread.new(number) do |my_number|
      Rake::Task[my_number].invoke
      Rake::Task[my_number].reenable
    end
  end
  threads.each { |thread| thread.join }
end
