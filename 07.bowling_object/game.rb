require_relative 'frame'

class Game
  def initialize(pinfall_text)
    @game_score = 0
    @pinfalls = format_pinfalls(pinfall_text)
  end

  def display_game_score
    p calc_score(@pinfalls)
  end

  private

  def format_pinfalls(pinfall_text)
    pinfalls = pinfall_text.split(',').map { |c| c == 'X' ? 10 : c.to_i }
  end

  def calc_score(pinfalls)
    frames = []
    @game_score =
      pinfalls.each_with_index.sum do |pinfall, index|
        frames << [] if next_frame?(frames)
        rolls = frames.last
        rolls << pinfall
        following_pinfalls = pinfalls[index.succ..]
        last_frame?(frames) ? pinfall : pinfall + add_bonus(rolls, following_pinfalls)
      end
  end

  def add_bonus(rolls, following_pinfalls)
    if strike?(rolls)
      following_pinfalls.first(2).sum
    elsif spare?(rolls)
      following_pinfalls.first
    else
      0
    end
  end

  def last_frame?(frames)
    frames.size == 10
  end

  def strike?(rolls)
    rolls[0] == 10
  end

  def spare?(rolls)
    rolls.sum == 10
  end

  def next_frame?(frames)
    rolls = frames.last
    !last_frame?(frames) && (frames.empty? || strike?(rolls) || rolls.size == 2)
  end
end

Game.new(ARGV[0]).display_game_score
