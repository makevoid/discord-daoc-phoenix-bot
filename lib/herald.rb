API_ROOT = "https://herald.playphoenix.online"

RP_WEEK = "guilds/realmpoints?time-frame=%s"
RP_WEEK_MID = "guilds/realmpoints?time-frame=%s&filter=midgard"
GUILD_NAME = "BIT" # our guild is called BIT, you'll have to do a little commands renaming ideally to make this work with yours
RP_WEEK_BIT = "g/#{GUILD_NAME}"
RANK_GUILD = "g/#{GUILD_NAME}"
CHAR_INFO = "c/%s"
GUILD_INFO = "g/%s"

def get_time_frame
  if Date.today.wday == 1 # mondays
    "last-48h"
  else
    "this-week"
  end
end

def get(req, name: nil, param2: nil) # TODO: implement one call with params
  time_frame = get_time_frame
  url = case req
  when :rp_week then RP_WEEK % time_frame
  when :rp_week_mid then RP_WEEK_MID % time_frame
  when :rp_week_bit then RP_WEEK_BIT
  when :rank_guild then RANK_GUILD
  when :char_info then CHAR_INFO % name
  when :guild_info then GUILD_INFO % name
  else
    raise "URL NOT FOUND"
  end
  url = "#{API_ROOT}/#{url}"
  resp = Net::HTTP.get_response URI url
  raise "Request failed ... aborting" unless resp.class == Net::HTTPOK
  resp.body
end


# TODO: REFACTOR: STARTS
#
# refactor out in their own modules parse methods, also deduplicate and simplify search code

# simplify search code by using selectors

def parse_rp_week_guilds(resp)
  resp = Nokogiri::HTML resp
  table = resp.css ".col-md-12"
  rows = table.css 'tr'
  rows = rows[0..25]
  guild_rps = []
  rows.each do |row|
    cells = row.css 'td'
    next if cells.empty?
    id, name, rp = cells.map(&:inner_text).map(&:strip)
    result = "##{id.ljust 2, ' '} - #{name.ljust(22, ' ')} - #{rp} RP"
    guild_rps << result
  end
  guild_rps
end

def parse_rp_week_bit(resp)
  resp = Nokogiri::HTML resp
  table = resp.css ".col-md-12"
  rows = table.css 'tr'
  guild_rps = []
  rows.each do |row|
    cells = row.css 'td'
    next if cells.empty?
    name, klass, _, _, _, _, rp, rp_48h = cells.map(&:inner_text).map(&:strip)
    rp = rp_48h if Date.today.wday == 1
    result = ["#{name.ljust(12, ' ')} - #{rp} RP", rp.gsub(/,/, '').to_i]
    guild_rps << result
  end
  guild_rps.sort_by!{ |row| -row[1] } # sort by rp
  guild_rps[0..24].map.with_index do |row, idx|
    "##{(idx+1).to_s.ljust 2, ' '} - #{row[0]}"
  end
end

module RankPlayerUtils
  def rank_row(resp:, query:, idx:)
    elem = resp.css "#{query} td:nth-child(#{idx+1})"
    elem.text.strip
  end
end
include RankPlayerUtils

def parse_rank_guild_player(resp:, idx:)
  query = ".row:nth-child(3) tr:nth-child(#{idx+1})"
  name  = rank_row resp: resp, query: query, idx: 0
  klass = rank_row resp: resp, query: query, idx: 1
  level = rank_row resp: resp, query: query, idx: 2
  rr    = rank_row resp: resp, query: query, idx: 3
  rp    = rank_row resp: resp, query: query, idx: 4

  { name: name, klass: klass, level: level, rr: rr, rp: rp }
end

def players_count(resp:)
  resp.css(".row:nth-child(3) tr td:nth-child(1)").size
end

def parse_rank_guild_players(resp:)
  players = []
  players_count(resp: resp).times do |idx|
    players << parse_rank_guild_player(resp: resp, idx: idx)
  end
  players
end

# TODO: add refinement

class Hash
  alias :f :fetch
end

GuildPlayers = -> (resp) {
  resp = Nokogiri::HTML resp
  player_ranks = parse_rank_guild_players resp: resp
  player_ranks.reject!{ |pr| !pr.f(:name) || pr.f(:name) == "" }
  player_ranks
}

def parse_rank_guild(resp, all:, sort: "TODO! sort")
  players = GuildPlayers.(resp)

  unless all
    players.select!{ |player| player.f(:level).to_i == 50 }
    players.reject!{ |player| player.f(:rr)[0].to_i < 4 }
  end

  # players.sort_by! ... TODO: sort

  { players: players, count: players.size }
end

def parse_single_char(resp)
  resp = Nokogiri::HTML resp
  elems = resp.css ".container-fluid div.col-md-12"
  elem = elems[0]
  result = nil
  elem.children.each do |child|
    next unless child.class == Nokogiri::XML::Text
    next if child.text.strip == ""
    result = child.text.strip.gsub(/\s+/, " ")
  end
  level = result.match(/Level (\d+) /)
  level = level[1].to_i
  { result: result, level: level }
end

def parse_single_char_full(resp)
  resp = Nokogiri::HTML resp
  elems = resp.css ".container-fluid div.col-md-6"
  rp_table = elems[0]
  rps = rp_table.search "table.border:nth-of-type(1) tr td:nth-of-type(2)"
  rps_all_time, rps_this_week, rps_last_48h = rps[0].text, rps[2].text, rps[3].text

  kills_table = elems[1]
  kills = kills_table.search "table.border:nth-of-type(1) tr td:nth-of-type(2)"
  kills_all_time, kills_this_week, kills_last_48h = kills[0].text, kills[2].text, kills[3].text

  dblows_table = elems[0]
  dblows = dblows_table.search "table.border:nth-of-type(2) tr td:nth-of-type(2)"
  dblows_all_time, dblows_this_week, dblows_last_48h = dblows[0].text, dblows[2].text, dblows[3].text

  deaths_table = elems[0]
  deaths = deaths_table.search "table.border:nth-of-type(3) tr td:nth-of-type(2)"
  deaths_all_time, deaths_this_week, deaths_last_48h = deaths[0].text, deaths[2].text, deaths[3].text

  {
    all_time: {
      rps: rps_all_time,
      kills: kills_all_time,
      dblows: dblows_all_time,
      deaths: deaths_all_time,
    },
    this_week: {
      rps: rps_this_week,
      kills: kills_this_week,
      dblows: dblows_this_week,
      deaths: deaths_this_week,
    },
    last_48h: {
      rps: rps_last_48h,
      kills: kills_last_48h,
      dblows: dblows_last_48h,
      deaths: deaths_last_48h,
    },
  }
end

def parse_guild_rp(resp)
  resp = Nokogiri::HTML resp
  elems = resp.css "table.border:nth-of-type(1):first tr:nth-of-type(1) td:nth-of-type(2)"
  elem = elems[0]
  rps = elem.text
  rps.gsub(/,/, '').to_i
end

# TODO: REFACTOR: ENDS

# -------------------


# bot/herald base methods (low level herald commmands)

def rp_week
  puts "GET rp_week"
  resp = get :rp_week
  rps_week = parse_rp_week_guilds resp
  rps_week.join "\n"
end

def rp_week_mid
  puts "GET rp_week_mid"
  resp = get :rp_week_mid
  rps_week = parse_rp_week_guilds resp
  rps_week.join "\n"
end

def rp_week_bit
  puts "GET rp_week_bit"
  resp = get :rp_week_bit
  rps_week = parse_rp_week_bit resp
  rps_week.join "\n"
end

def char_info(char:)
  puts "GET char_info - char: #{char}"
  resp = get :char_info, name: char
  char_info = parse_single_char resp
  char_info.fetch :result
end

def rank_guild(all=nil)
  puts "GET rank_guild"
  resp = get :rank_guild
  player_ranks = parse_rank_guild resp, all: all
  content = []
  player_ranks.f(:players).each do |rank|
    content << "#{rank.f(:name).ljust 11, ' '} - #{rank.f(:rr)} (#{rank.f(:klass)})"
  end
  content.join "\n"
end

def char_info_full(char:)
  puts "GET char_info - char: #{char}"
  resp = get :char_info, name: char
  info = parse_single_char_full resp
  last_48h = info.fetch :last_48h
  this_week = info.fetch :this_week
  "
This week - RPs: #{this_week.fetch(:rps).ljust(8, ' ')} | K/D/DB: #{this_week.fetch :kills} / #{this_week.fetch :deaths} / #{this_week.fetch :dblows}

Last 48h  - RPs: #{last_48h.fetch(:rps).ljust(8, ' ')} | K/D/DB: #{last_48h.fetch :kills} / #{last_48h.fetch :deaths} / #{last_48h.fetch :dblows}
  "
end

RPGuildGet = -> {
  resp = get :guild_info, name: "BIT"
  parse_guild_rp resp
}
