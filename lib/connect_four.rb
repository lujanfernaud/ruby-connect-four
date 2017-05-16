class Player
  attr_reader :name, :mark, :board

  def initialize(name:, mark:, board: [])
    @name  = name
    @mark  = mark
    @board = board
  end
end

class Computer
  attr_accessor :name, :mark
  attr_reader   :board

  def initialize(mark:, board: [])
    @name  = "Computer"
    @mark  = mark
    @board = board
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

  def print
    system "clear" or system "cls"
    puts "\n"
    puts "     1 | 2 | 3 | 4 "
    puts "   -----------------"
    puts " a | #{grid[:a][0]}   #{grid[:a][1]}   #{grid[:a][2]}   #{grid[:a][3]} |"
    puts "   ----------------"
    puts " b | #{grid[:b][0]}   #{grid[:b][1]}   #{grid[:b][2]}   #{grid[:b][3]} |"
    puts "   ----------------"
    puts " c | #{grid[:c][0]}   #{grid[:c][1]}   #{grid[:c][2]}   #{grid[:c][3]} |"
    puts "   ----------------"
    puts " d | #{grid[:d][0]}   #{grid[:d][1]}   #{grid[:d][2]}   #{grid[:d][3]} |"
    puts "\n"
  end
end

class Game
  attr_accessor :players, :human1, :human2
  attr_reader   :board, :computer

  def initialize
    @board    = Board.new
    @players  = 1
    @human1   = Player.new(name: "Human 1", mark: "X", board: board)
    @human2   = Player.new(name: "Human 2", mark: "O", board: board)
    @computer = Computer.new(mark: "O", board: board)
  end

  def setup
    board.print
  end
end
