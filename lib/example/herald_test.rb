require_relative '../../env'
require_relative '../herald'

puts "RPs this week - Guild (All)\n---"
resp = get :rp_week
puts resp
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

puts "Done"
