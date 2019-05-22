desc "Run the bot"
task :run do
  sh "bundle exec ruby discord-bot.rb"
end

desc "Herald scrape"
task :herald do
  sh "bundle exec ruby lib/herald_test.rb"
end

desc "Herald scrape"
task :herald2 do
  sh "bundle exec ruby lib/herald_test2.rb"
end

desc "Push notification test"
task :push do
  sh "bundle exec ruby lib/push.rb"
end

desc "LVLup notifier"
task :lvlup_notifier do
  sh "bundle exec ruby lib/lvlup_notifier.rb"
end

task default: :run
