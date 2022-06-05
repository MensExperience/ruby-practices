require_relative 'frame'

class Game
  def initialize(pinfall_text)
    @game_score = 0
    @pinfalls = format_pinfalls(pinfall_text)
    @frames = create_frames(@pinfalls)
  end

  def calc_game_score
    @frames.each_with_index.sum do |frame, i|
      @game_score += frame.calc_score
      @game_score += add_bonus(@frames, i)
    end
  puts @game_score
  pp @frames
  end

  private

  def format_pinfalls(pinfall_text)
    pinfalls = pinfall_text.split(',').map { |c| c == 'X' ? 10 : c.to_i }
  end

  def create_frames(pinfalls)
    rolls = create_rolls(pinfalls)
    @frames = rolls.map { |f| Frame.new(f[0], f[1], f[2]) }
  end

  def create_rolls(pinfalls)
    rolls = []
    one_roll = []

    pinfalls.each do |pinfall|
      one_roll << pinfall
      if (rolls.count < 9)  && (one_roll.first == 10 || one_roll.size == 2)
        rolls << one_roll
        one_roll = []
      end
    end
    rolls << one_roll
  end

  def add_bonus(frames, i)
    if i + 1 >= 10
      0
    else
      10
    end
  end
end

Game.new(ARGV[0]).calc_game_score
