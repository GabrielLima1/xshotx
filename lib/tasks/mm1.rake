task :one do
  puts "start one"
  sleep 10 * rand
  puts "one done"
end

task :two do
  puts "start two"
  sleep 10 * rand
  puts "two done"
end

task :three do
  puts "start three"
  sleep 10 * rand
  puts "three done"
end

desc "Submit all feed to amazon for SITE"
task :do_all do
  threads = []
  %w{one one one}.each do |number|
    threads << Thread.new(number) do |my_number|
      Rake::Task[my_number].invoke
      # Rake::Task[my_number].reenable      
    end
  end
  threads.each { |thread| thread.join }
end
