require "pry"

class Player
  attr_accessor :name, :mark
  attr_reader   :board

  def initialize(name:, mark:, board: [])
    @name  = name
    @mark  = mark
    @board = board
  end

  def throw(column)
    board.position_mark_in_column(column.to_i, mark)
  end
end

class Computer < Player
  attr_accessor :name,  :mark
  attr_reader   :board, :human_mark

  def initialize(mark:, human_mark:, board: [])
    @name       = "Computer"
    @mark       = mark
    @human_mark = human_mark
    @board      = board
  end

  def throw
    board.print_board
    puts "Computer turn..."
    sleep rand(1..2) * 0.5
    board.position_mark_in_column(choose_location, mark)
  end

  def choose_location
    3.times do |i|
      match_in_rows = check_rows(iteration: i)
      return match_in_rows if match_in_rows

      match_in_columns = check_columns(iteration: i)
      return match_in_columns if match_in_columns

      match_in_diagonals = check_diagonals(iteration: i)
      return match_in_diagonals if match_in_diagonals
    end

    choose_random_location
  end

  def check_rows(iteration:)
    board.grid.each.with_index do |row, index|
      array = []
      row.each { |column| array << column }

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      next if empty_slots.zero? && index < 3
      return false if empty_slots.zero?

      if computer_marks == 3 && human_marks.zero?
        return array.index("-") + 1
      end

      if computer_marks == 2 && human_marks.zero? && iteration == 1
        return array.index("-") + 1
      end

      if computer_marks == 1 && human_marks.zero? && iteration == 2
        return array.index("-") + 1
      end

      next if computer_mark_or_no_human_mark(array) && index < 3
      return false if computer_mark_or_no_human_mark(array)
      return false if iteration.zero? && human_marks < 2

      return array.index("-") + 1
    end
  end

  def check_columns(iteration:)
    4.times do |column|
      array = []
      board.grid.each.with_index do |_row, index|
        array << board.grid[index][column]
      end

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      next if empty_slots.zero?

      if computer_marks == 3 && human_marks.zero?
        return column + 1
      end

      if computer_marks == 2 && human_marks.zero? && iteration == 1
        return column + 1
      end

      if computer_marks == 1 && human_marks.zero? && iteration == 2
        return column + 1
      end

      next if computer_mark_or_no_human_mark(array) && column < 3
      return false if computer_mark_or_no_human_mark(array)
      return false if iteration.zero? && human_marks < 2

      return column + 1
    end
  end

  def check_diagonals(iteration:)
    position = diagonal_from_left_bottom(iteration)
    return position if position
    position = diagonal_from_right_bottom(iteration)
    return position if position
    false
  end

  def diagonal_from_left_bottom(iteration)
    array = build_diagonal_left_array

    computer_marks = array.join.count(mark)
    human_marks    = array.join.count(human_mark)
    empty_slots    = array.join.count("-")
    column         = array.index("-")

    return false unless empty_slots || supportive_column_left(column)

    return diagonal_attack(computer_marks, column, iteration) if human_marks.zero?
    return diagonal_defend(human_marks, column) if computer_marks.zero?
  end

  def build_diagonal_left_array
    array  = []
    column = 0
    board.grid.reverse.map.with_index do |_row, index|
      array << board.grid.reverse[index][column]
      column += 1
    end
    array
  end

  def supportive_column_left(column)
    array = []
    board.grid.reverse.each.with_index do |_row, index|
      array << board.grid.reverse[index][column]
    end
    column == array.index("-")
  end

  def diagonal_from_right_bottom(iteration)
    array = build_diagonal_right_array

    computer_marks = array.join.count(mark)
    human_marks    = array.join.count(human_mark)
    empty_slots    = array.join.count("-")
    column         = array.count { |v| v == "-" } - 1

    return false unless empty_slots || supportive_column_right(column)

    return diagonal_attack(computer_marks, column, iteration) if human_marks.zero?
    return diagonal_defend(human_marks, column) if computer_marks.zero?
  end

  def build_diagonal_right_array
    array  = []
    column = 0
    board.grid.each.with_index do |_row, index|
      array << board.grid[index][column]
      column += 1
    end
    array
  end

  def supportive_column_right(column)
    array = []
    board.grid.each.with_index do |_row, index|
      array << board.grid[index][column]
    end

    column == array.count { |v| v == "-" } - 1
  end

  def diagonal_attack(computer_marks, column, iteration)
    case computer_marks
    when 3 then column + 1
    when 2 then column + 1 if iteration == 1
    else false
    end
  end

  def diagonal_defend(human_marks, column)
    case human_marks
    when 2..3 then column + 1
    else false
    end
  end

  def computer_mark_or_no_human_mark(array)
    computer_mark = array.any?  { |mark| mark == self.mark }
    no_human_mark = array.none? { |mark| mark == human_mark }
    computer_mark || no_human_mark
  end

  def choose_random_location
    rows    = [*0..3]
    columns = [*0..3]

    loop do
      row      = rows.sample
      column   = columns.sample
      location = board.grid[row][column]
      return column + 1 if location == "-"
    end
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

  def position_available?(column)
    grid.map { |row| row[column - 1] }.any? { |slot| slot == "-" }
  end

  def the_position_is_not_available(column)
    print_board
    puts "The column #{column} is full.\n\n"
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
    @computer = Computer.new(mark: "O", human_mark: human1.mark, board: board)
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
      first_turn
      second_turn
    end
  end

  def first_turn
    human1.throw(introduce_position(human1))
    check_for_winner(human1)
  end

  def second_turn
    case players
    when 1
      computer.throw
      check_for_winner(computer)
    when 2
      human2.throw(introduce_position(human2))
      check_for_winner(human2)
    end
  end

  def introduce_position(player = computer)
    case players
    when 1 then puts "Introduce a position:"
    when 2 then puts "#{player.name}, introduce a position:"
    end

    loop do
      input = STDIN.gets.chomp
      return input if input =~ /^[1-4]$/
      exit_game    if input == "exit".downcase

      board.print_board
      puts "'#{input}' is not a correct position.\n\nIntroduce a position:"
    end
  end

  def set_players
    puts "Choose players, 1 or 2?"
    input = STDIN.gets.chomp.to_i
    self.players = input
  end

  def ask_players_names
    ask_human1_name
    ask_human2_name
  end

  def ask_human1_name
    board.print_board
    puts "Player 1 name:"
    human1.name = STDIN.gets.chomp
  end

  def ask_human2_name
    board.print_board
    puts "Player 2 name:"
    human2.name = STDIN.gets.chomp
  end

  def check_for_winner(last_player)
    raise ArgumentError unless last_player.is_a?(Player)

    check_rows(last_player)
    check_columns(last_player)
    check_diagonals(last_player)

    finish_game if there_is_no_winner?
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

  def there_is_no_winner?
    board.grid.flatten.none? { |value| value == "-" }
  end

  def finish_game
    puts "There's no winner. Try again? (y/n)"
    try_again
  end

  def the_winner_is(last_player)
    case last_player.name
    when "Computer" then puts "Computer WINS! Try again? (y/n)"
    when "Human 1"  then puts "You WIN! Try again? (y/n)"
    else puts "#{last_player.name} WINS! Try again? (y/n)"
    end
    try_again
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

# Game.new.setup
