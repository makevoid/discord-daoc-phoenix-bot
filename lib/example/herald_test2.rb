require_relative '../../env'
require_relative '../herald'

puts "Rank guild \n---\n"
resp = get :rank_guild
player_ranks = parse_rank_guild resp, all: false
content = []
player_ranks.f(:players).each do |rank|
  content << "#{rank.f(:name).ljust 11, ' '} - #{rank.f(:rr)} (#{rank.f(:klass)})"
end
content = content.join "\n"
puts "#{content}\n\n"

exit

char = "suppla"
puts "Char info - #{char}\n---"
resp = get :char_info, name: char
char_info = parse_single_char_full resp
p char_info

puts "-"*30

info = char_info_full char: char
puts info

puts "Done"
