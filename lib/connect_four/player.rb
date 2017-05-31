class Player
  attr_accessor :name
  attr_reader   :mark

  def initialize(name:, mark:)
    @name = name
    @mark = mark
  end
end
