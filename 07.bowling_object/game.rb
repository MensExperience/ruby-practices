require_relative 'frame'

class Game
  def initialize(text_scores)
    format_frames(text_scores)
  end
#TODO Frameクラスにtext_scoresをフレームごとに投げる→Frame型の配列を作成。
#（10フレーム以降の挙動注意）→Frameクラスインスタンスは、shotクラスのインスタンスからの応答値を合計する処理に留めて、厳密なストライクやスペア処理などはGameクラスで行う様にしていく。
  def display_game_score
    game_score =
      @frames.each_with_index.sum do |frame, i|
        strike = (frame.first == 10)
        spare =(!strike && frame.sum == 10)
        last_frame = (i + 1 >= 10)
        next_frame = @frames[i.next]
        after_next_frame = @frames[i + 2]

        if last_frame
          frame.sum
        elsif strike
          double = (@frames[i.next].first == 10)
          if double
            20 + after_next_frame.first
          else
            10 + next_frame.sum
          end
        elsif spare
          10 + next_frame.first
        else
          frame.sum
        end
      end
    puts game_score
  end

  private

  def format_frames(text_scores)
    text_scores = text_scores.split(',')
    text_frame = text_scores.flat_map do |text_score|
      text_score == 'X' ? [10, 0] : text_score.to_i
    end
    @frames = text_frame.each_slice(2).to_a
    p @frames
  end
end

text_scores = ARGV[0]
Game.new(text_scores).display_game_score
