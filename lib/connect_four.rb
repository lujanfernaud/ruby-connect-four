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

class Board
  attr_accessor :grid

  def initialize
    @grid = { a: ["-", "-", "-", "-"],
              b: ["-", "-", "-", "-"],
              c: ["-", "-", "-", "-"],
              d: ["-", "-", "-", "-"] }
  end
end

class Game
  attr_accessor :players, :human1, :human2
  attr_reader   :board, :computer

  def initialize
    @board    = Board.new
    @players  = 1
    @human1   = Player.new(name: "Human 1", mark: "X")
    @human2   = Player.new(name: "Human 2", mark: "O")
    @computer = Computer.new(mark: "O")
  end
end
