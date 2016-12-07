#encoding: utf-8
namespace :acc do
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
	p "Fim!"
  end
end
