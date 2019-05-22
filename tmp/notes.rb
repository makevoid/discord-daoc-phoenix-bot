# sample code notes

# ----

# Constants

DaocClassesMid = %w(Healer Warrior Skald Savage Runemaster Spiritmaster Thane Bonedancer Berserker Hunter Shadowblade)
DaocClasses = DaocClassesMid


def parse_rank_guild_class(resp, klass:)
  DaocClasses
end

def parse_rank_ombre
  # Shadowblade + Hunter
end

# ----

# sample usage

puts "RPs this week - Guild (All)\n---"
resp = get :rp_week
rps_week = parse_rp_week_guilds resp
puts rps_week.join "\n"
puts "\n\n"

puts "RPs this week - Guild (Midgard)\n---"
resp = get :rp_week_mid
rps_week = parse_rp_week_guilds resp
puts rps_week.join "\n"
puts "\n\n"

puts "RPs this week - BIT\n---"
resp = get :rp_week_bit
rps_week = parse_rp_week_bit resp
puts rps_week.join "\n"

char = "makevoid"
# char = "suppla"
puts "Char info - #{char}\n---"
resp = get :char_info, name: char
char_info = parse_single_char resp
p char_info

puts "done!"
