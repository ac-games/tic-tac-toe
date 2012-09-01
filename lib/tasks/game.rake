# coding: utf-8

namespace :db do
  desc "Удаление устаревших игр"
  task :delete_old_created_games => :environment do
    during_minutes = ENV['DURING_MINUTES'] || 5
    games = Game.where "status = ? AND created_at < ?",
                       :created,
                       Time.now - during_minutes.to_i.minutes
    puts "Удаление игр, застоявшихся более чем на #{during_minutes} минут..."
    if games.any?
      games.map { |game| game.delete }
      puts "Всего удалено #{games.count} игр."
    else
      puts "В базе нет не начатых игр, созданных так давно"
    end
  end
end
