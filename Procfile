web: if [ "$RAILS_ENV" = "production" ]; then RAILS_ENV=production bundle exec rails s -b 127.0.0.1 -p 3000; else bundle exec rails s -p 3000; fi
bot: bundle exec ruby telegram_bot.rb