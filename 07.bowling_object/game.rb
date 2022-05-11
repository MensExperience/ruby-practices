require_relative 'frame'

class Game
  def initialize(pinfall_text)
    @frames = format_pinfalls(pinfall_text)
  end

  def display_game_score
    @frames
  end

  private

  def format_pinfalls(pinfall_text)
    pinfalls = pinfall_text.split(',').map { |c| c == 'X' ? 10 : c.to_i }
    frames = []
    pinfalls.each_with_index do |pinfall, index|
      frames << [] if next_frame?(frames)
      rolls = frames.last
      rolls << pinfall
    end
    frames
  end

  def last_frame?(frames)
    frames.size == 10
  end

  def strike?(rolls)
    rolls[0] == 10
  end

  def next_frame?(frames)
    rolls = frames.last
    !last_frame?(frames) && (frames.empty? || strike?(rolls) || rolls.size == 2)
  end
end

p Game.new(ARGV[0]).display_game_score
