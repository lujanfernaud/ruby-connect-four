class Game
  attr_accessor :board, :players, :human1, :human2
  attr_reader   :computer

  def initialize
    @board    = Board.new(self)
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
  rescue Interrupt
    exit_game
  end

  def start
    loop do
      board.print_board
      first_turn
      second_turn
    end
  rescue Interrupt
    exit_game
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
    check_inputted_position
  end

  def check_inputted_position
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

    loop do
      input = STDIN.gets.chomp.to_i
      return self.players = input if input.to_s =~ /^[1-2]$/

      board.print_board
      puts "1 or 2 players?"
    end
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
      grid = grid.reverse
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
    board.print_board
    puts "There's no winner. Try again? (y/n)"
    try_again
  end

  def the_winner_is(last_player)
    board.print_board
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
