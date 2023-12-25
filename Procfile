web: if [ "$RAILS_ENV" = "production" ]; then RAILS_ENV=production bundle exec puma -C config/puma.rb; else bundle exec rails s -p 3000; fi
bot: bundle exec ruby telegram_bot.rb