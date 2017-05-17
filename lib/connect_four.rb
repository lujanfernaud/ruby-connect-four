class Player
  attr_accessor :name, :mark
  attr_reader   :board

  def initialize(name:, mark:, board: [])
    @name  = name
    @mark  = mark
    @board = board
  end

  def throw(column)
    raise ArgumentError unless column.is_a?(Integer)
    board.position_mark_in_column(column, mark)
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
    @grid = [["-", "-", "-", "-"],
             ["-", "-", "-", "-"],
             ["-", "-", "-", "-"],
             ["-", "-", "-", "-"]]
  end

  def print_board
    system "clear" or system "cls"
    puts "\n"
    puts "     1 | 2 | 3 | 4 "
    puts "   -----------------"
    puts " a | #{grid[0][0]}   #{grid[0][1]}   #{grid[0][2]}   #{grid[0][3]} |"
    puts "   ----------------"
    puts " b | #{grid[1][0]}   #{grid[1][1]}   #{grid[1][2]}   #{grid[1][3]} |"
    puts "   ----------------"
    puts " c | #{grid[2][0]}   #{grid[2][1]}   #{grid[2][2]}   #{grid[2][3]} |"
    puts "   ----------------"
    puts " d | #{grid[3][0]}   #{grid[3][1]}   #{grid[3][2]}   #{grid[3][3]} |"
    puts "\n"
  end

  def position_mark_in_column(column, mark)
    grid.reverse.each do |row|
      next if row[column - 1] != "-"
      row[column - 1] = mark
      break
    end
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
    board.print_board
    set_players
    ask_players_names if players == 2
    start
  end

  def start
  end

  def introduce_position(player = computer)
    case players
    when 1 then puts "Introduce a position:"
    when 2 then puts "#{player.name}, introduce a position:"
    end

    STDIN.gets.chomp.to_i
  end

  def set_players
    puts "Choose players, 1 or 2?"
    input = STDIN.gets.chomp
    self.players = input
  end

  def ask_players_names
    board.print_board
    puts "Player 1 name:"
    human1.name = STDIN.gets.chomp
    board.print_board
    puts "Player 2 name:"
    human2.name = STDIN.gets.chomp
  end
end
