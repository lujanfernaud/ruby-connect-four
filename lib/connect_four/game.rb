class Game
  attr_accessor :players, :human1, :human2
  attr_reader   :board, :computer

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
    human1.throw(introduce_column(human1))
    check_for_winner(human1)
  end

  def second_turn
    case players
    when 1
      computer.throw
      check_for_winner(computer)
    when 2
      human2.throw(introduce_column(human2))
      check_for_winner(human2)
    end
  end

  def introduce_column(player = computer, print_board: true)
    board.print_board if print_board
    case players
    when 1 then puts "Introduce a column:"
    when 2 then puts "#{player.name}, introduce a column:"
    end
    check_inputted_column
  end

  def check_inputted_column
    loop do
      input = STDIN.gets.chomp
      return input if input =~ /^[1-7]$/
      exit_game    if input == "exit".downcase

      board.print_board
      puts "'#{input}' is not a correct column.\n\nIntroduce a column:"
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
      row.each.with_index do |_mark, index|
        break if index == 4
        slice = row.slice(index...index + 4)
        the_winner_is(last_player) if slice.all? { |mark| mark == last_player.mark }
      end
    end
  end

  def check_columns(last_player)
    7.times do |col|
      column = board.grid.map { |row| row[col] }

      column.each.with_index do |_mark, index|
        break if index == 3
        slice = column.slice(index...index + 4)
        return the_winner_is(last_player) if slice.all? { |mark| mark == last_player.mark }
      end
    end
  end

  def check_diagonals(last_player)
    sides = [from_left_bottom, from_right_bottom]

    sides.each do |side|
      diagonals = build_diagonals_from(side)

      diagonals.each.with_index do |_mark, index|
        break if index == diagonals.length - 5
        slice = diagonals.slice(index...index + 4)
        return the_winner_is(last_player) if slice.all? { |mark| mark == last_player.mark }
      end
    end
  end

  def build_diagonals_from(from)
    diagonals = []
    from.each_value do |pair|
      next if pair == :left || pair == :right

      y     = pair[:start][:y]
      x     = pair[:start][:x]
      marks = pair[:finish][:x] - pair[:start][:x] + 1

      marks.times do
        diagonals << board.grid[y][x]
        case from[:side]
        when :left  then y -= 1
        when :right then y += 1
        end

        x += 1
      end
    end

    diagonals
  end

  def from_left_bottom
    { side:       :left,
      diagonal1: { start: { y: 3, x: 0 }, finish: { y: 0, x: 3 } },
      diagonal2: { start: { y: 4, x: 0 }, finish: { y: 0, x: 4 } },
      diagonal3: { start: { y: 5, x: 0 }, finish: { y: 0, x: 5 } },
      diagonal4: { start: { y: 5, x: 1 }, finish: { y: 0, x: 6 } },
      diagonal5: { start: { y: 5, x: 2 }, finish: { y: 1, x: 6 } },
      diagonal6: { start: { y: 5, x: 3 }, finish: { y: 2, x: 6 } } }
  end

  def from_right_bottom
    { side:        :right,
      diagonal1: { start: { y: 2, x: 0 }, finish: { y: 5, x: 3 } },
      diagonal2: { start: { y: 1, x: 0 }, finish: { y: 5, x: 4 } },
      diagonal3: { start: { y: 0, x: 0 }, finish: { y: 5, x: 5 } },
      diagonal4: { start: { y: 0, x: 1 }, finish: { y: 5, x: 6 } },
      diagonal5: { start: { y: 0, x: 2 }, finish: { y: 4, x: 6 } },
      diagonal6: { start: { y: 0, x: 3 }, finish: { y: 3, x: 6 } } }
  end

  def finish_game
    board.print_board
    puts "There's no winner. Try again? (y/n)"
    try_again
  end

  def there_is_no_winner?
    board.grid.flatten.none? { |value| value == "-" }
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
    loop do
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
  end

  def exit_game
    system "clear" or system "cls"
    puts "Thanks for playing. Hope you liked it!\n\n"
    exit
  end
end
