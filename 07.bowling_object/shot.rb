class Shot
  attr_reader :point

  def initialize(pinfall)
    @point = pinfall.to_i
  end
end
