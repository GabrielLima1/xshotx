#encoding: utf-8
namespace :acc1 do
  desc "Count message of Accounts"
  task app: :environment do
	p Account.all.length
    Account.find_each do |conta|
      if conta.status == true
        conta.status = false
        conta.save
      end
    end
	@b.close
	p Account.all.length
	p "Fim! Acc1"
	p "Iniciando Acc2..."
  Rake::Task['acc2:app'].execute
  end
end
