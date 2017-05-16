class Player
  attr_reader :name, :mark

  def initialize(name:, mark:)
    @name = name
    @mark = mark
  end
end

class Computer
  attr_accessor :name, :mark

  def initialize(mark:)
    @name = "Computer"
    @mark = mark
  end
end
