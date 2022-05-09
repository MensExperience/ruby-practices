require_relative 'shot'
#大まかな実装のみ（機能していない）
class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @frame = Shot.new(first_shot)
    @frame = Shot.new(second_shot)
    @frame = Shot.new(third_shot)
    # TODO 10フレーム目のthird_shotをどの様に扱うか？→現状10フレーム以降はトータルに合算するのみの記述だが、できれば10フレーム目に3投目まで保持させたい。
  end

  def calc_score
    #TODO うまくいってない
    [@first_shot.point, @second_shot.point, @third_shot.point].sum
  end
end
