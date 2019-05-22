module ToMil
  def to_mil(number)
    (number.to_f / 1_000_000).floor
  end
end

class Guild
  include DataMapper::Resource

  class << self
    include ToMil
  end

  property :id, Serial
  property :rp, Integer

  def self.rp_ding!(rp_curr:, ding:)
    return (new.save! && nil) if Guild.count == 0
    guild = Guild.first
    rp = guild.rp
    guild.rp = rp_curr
    guild.save!
    
    if to_mil(rp_curr) == to_mil(rp)+1
      puts "RP DING! - RP: #{rp_curr}"
      ding.()
      true
    end
  end

end
