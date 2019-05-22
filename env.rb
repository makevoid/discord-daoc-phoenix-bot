require 'net/http'
require "net/https"
require 'date'

require 'bundler'
Bundler.require :default

path = File.expand_path '../', __FILE__
PATH = path

require_relative 'constants'
require_relative 'lib/herald'
require_relative 'lib/env_secret'

raise "No secret `CLIENT_SECRET`" unless defined? CLIENT_SECRET
raise "No secret `BOT_TOKEN`" unless defined? BOT_TOKEN
raise "No secret `PUSHED_APP_SECRET`" unless defined? PUSHED_APP_SECRET

# DISCORD
CLIENT_KEY = "558267878462324736"

CHANNEL_ID = "277589735780777984" # BIT #general

# PUSHED
PUSHED_APP_KEY = "jGu2mv5YlezTFekha1rY"


# BOT = Discordrb::Bot.new token: BOT_TOKEN
BOT = Discordrb::Commands::CommandBot.new token: BOT_TOKEN, prefix: '!'

# use this url to authorize (replace client id with your `client_id`):
# https://discordapp.com/oauth2/authorize?&client_id=558267878462324736&scope=bot&permissions=8


# DB

DataMapper::Logger.new $stdout, :info

DataMapper.setup :default, "sqlite://#{PATH}/db/db.sqlite"
# DataMapper.setup :default, 'mysql://root:foo@localhost/pp_production'

require_relative 'models/guild'

DataMapper.finalize

APP_ENV = ENV["RACK_ENV"] || "development"

begin
  Guild.count
rescue DataObjects::SyntaxError => e
  puts "No guilds tabl found, migrating!"
  DataMapper.auto_migrate!
end
