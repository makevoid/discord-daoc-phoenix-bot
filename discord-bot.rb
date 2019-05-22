require_relative 'env'

BOT.command :ping do |evt|
  evt.respond 'Pong!'
end

# bot high level commmands

Help = -> (evt) {
  evt.respond "```
!who NAME                - retrieves info about char - prende le info del PG nomepg
!stats NAME              - retrieves stats about char - Last week & 48h: RPs, Kills, Deaths + Deathblows
!rp-guild / !rp-gilda    - fetches the guild RPs - total (prende gli RP gilda in tempo reale - RP totali)
!rank-guild / !rank-bit  - List of guild (BIT) members
!rp-mid   / !rp-midgard  - RPs realm (Midgard, this week) (RP Reame - questa settimana)
!rp-total / !rp-tutti    - RPs overall (this week) (RP totali - questa settimana)
!help     / !comandi     - displays this message (mostra questo messaggio)
```"
}

RpGuild = -> (evt) {
  puts "rp-gilda"
  evt.respond "```#{rp_week_bit}```"
}

RpMid = -> (evt) {
  puts "rp-mid"
  evt.respond "```#{rp_week_mid}```"
}

RpAll = -> (evt) {
  puts "rp-tutti"
  evt.respond "```#{rp_week}```"
}

Who = -> (evt, char_name) {
  puts "char-info: #{char_name}"
  info = char_info char: char_name
  evt.respond "```#{info}```"
}

Stats = -> (evt, char_name) {
  puts "char-info-full: #{char_name}"
  info = char_info_full char: char_name
  evt.respond "```#{info}```"
}

RankGuild = -> (evt) {
  puts "rank-guild"
  evt.respond "```#{rank_guild}```"
}

RankGuildAll = -> (evt) {
  puts "rank-guild (:all)"
  evt.respond "```#{rank_guild(:all)[0..1980]}...```"
}

# bot chat commands

BOT.command :"help" do |evt|
  Help.(evt)
end

BOT.command :"comandi" do |evt|
  Help.(evt)
end

BOT.command :"rp-gilda" do |evt|
  RpGuild.(evt)
end

BOT.command :"rp-guild" do |evt|
  RpGuild.(evt)
end

BOT.command :"rp-mid" do |evt|
  RpMid.(evt)
end

BOT.command :"rp-midgard" do |evt|
  RpMid.(evt)
end

BOT.command :"rp-realm" do |evt|
  RpMid.(evt)
end

BOT.command :"rp-tutti" do |evt|
  RpAll.(evt)
end

BOT.command :"rp-all" do |evt|
  RpAll.(evt)
end

BOT.command :"rp-total" do |evt|
  RpAll.(evt)
end

BOT.command :"who", min_args: 1, max_args: 1 do |evt, char_name|
  Who.(evt, char_name)
end

BOT.command :"stats", min_args: 1, max_args: 1 do |evt, char_name|
  Stats.(evt, char_name)
end

BOT.command :"rank-guild" do |evt|
  RankGuild.(evt)
end

BOT.command :"rank-bit" do |evt|
  RankGuild.(evt)
end

BOT.command :"rank-guild-all" do |evt|
  RankGuildAll.(evt)
end

BOT.command :user do |evt|
  evt.user.name
end


# main

Thread.abort_on_exception = true

FormatNum = -> (number) {
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
}

DingRpGuild = -> {
  message = "DING! #{FormatNum.(RPGuildGet.())} RP! Congratz BITs!"
  BOT.send_message CHANNEL_ID, message
}

ChanAlertsMainLoop = -> {
  loop do
    #puts Guild.all.inspect
    Guild.rp_ding! rp_curr: RPGuildGet.(), ding: DingRpGuild
    sleep 60
  end
}

Thread.new do
  ChanAlertsMainLoop.()
end

BOT.run
