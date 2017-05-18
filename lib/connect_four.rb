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
  attr_reader   :reset

  def initialize
    create_grid
  end

  def create_grid
    @grid = Array.new(4) { Array.new(4) { "-" } }
  end

  def reset
    create_grid
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
  attr_accessor :board, :players, :human1, :human2
  attr_reader   :computer

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
    loop do
      board.print_board
      human1.throw(introduce_position(human1))
      check_for_winner(human1)
    end
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

  def check_for_winner(last_player)
    raise ArgumentError unless last_player.is_a?(Player)
    check_rows(last_player)
    check_columns(last_player)
    check_diagonals(last_player)
  end

  def check_rows(last_player)
    board.grid.each do |row|
      the_winner_is(last_player) if row.all? { |mark| mark == last_player.mark }
    end
  end

  def check_columns(last_player)
    4.times do |column|
      array = []
      board.grid.each do |row|
        array << true if row[column] == last_player.mark
      end

      return the_winner_is(last_player) if array.length == 4
    end
  end

  def check_diagonals(last_player)
    grid = board.grid

    2.times do
      check_marks_in_diagonal(grid, last_player)
      grid.reverse!
    end
  end

  def check_marks_in_diagonal(grid, last_player)
    4.times do |column|
      array = []
      grid.each do |row|
        array << true if row[column] == last_player.mark
        column += 1
      end

      return the_winner_is(last_player) if array.length == 4
    end
  end

  def there_is_no_winner
    array = []
    board.grid.each { |row| row.each { |value| array << value } }
    array.none? { |value| value == "-" }
  end

  def finish_game
    puts "There's no winner. Try again? (Y/N)"
    try_again
  end

  def the_winner_is(last_player)
    case players
    when 1 then puts "You WIN!"
    when 2 then puts "#{last_player.name} WINS!"
    end
  end

  def try_again
    case STDIN.gets.chomp.downcase
    when "y"
      board.reset
      start
    when "n"
      exit_game
    else
      board.print_board
      puts "Please type 'y' or 'n'."
    end
  end

  def exit_game
    system "clear" or system "cls"
    puts "Thanks for playing. Hope you liked it!\n\n"
    exit
  end
end
