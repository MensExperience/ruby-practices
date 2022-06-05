require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot, third_shot)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot)
  end

  def calc_score
    [@first_shot.point, @second_shot.point, @third_shot.point].sum
  end

  def strike?
    @first_shot.point == 10
  end

  def spare?
    !strike? && [@first_shot.point, @second_shot.point].sum == 10
  end
end
