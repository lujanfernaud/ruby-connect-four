class Judge
  attr_reader :game, :board, :printer

  def initialize(game, board)
    @game    = game
    @board   = board
    @printer = game.printer
  end

  def check_for_winner(last_player)
    check_rows(last_player)
    check_columns(last_player)
    check_diagonals(last_player)

    finish_game if there_is_no_winner?
  end

  private

  def count_marks(last_player, line)
    match = line.join.match(/#{last_player.mark}{4}/)
    count = match[0].count(last_player.mark) if match
    return the_winner_is(last_player) if count == 4
  end

  def check_rows(last_player)
    board.grid.each do |row|
      count_marks(last_player, row)
    end
  end

  def check_columns(last_player)
    7.times do |col|
      column = board.grid.map { |row| row[col] }
      count_marks(last_player, column)
    end
  end

  def check_diagonals(last_player)
    board.diagonals.each do |side|
      diagonal = build_diagonals_from(side)
      count_marks(last_player, diagonal)
    end
  end

  def build_diagonals_from(side)
    marks = []
    side.each_value do |pair|
      next if pair == :left || pair == :right

      y = pair[:start][:y]
      x = pair[:start][:x]

      add_marks(pair, side[:side], y, x, marks)
    end
    marks
  end

  def add_marks(diagonal, side, y, x, marks)
    start  = diagonal[:start][:x]
    finish = diagonal[:finish][:x]

    (start..finish).each do
      marks << board.grid[y][x]
      y  = side == :left ? y - 1 : y + 1
      x += 1
    end
    marks << "|"
  end

  def finish_game
    printer.print_board
    puts "There's no winner. Try again? (y/n)"
    game.try_again
  end

  def there_is_no_winner?
    board.grid.flatten.none? { |value| value == "-" }
  end

  def the_winner_is(last_player)
    printer.print_board
    case last_player.name
    when "Computer" then puts "Computer WINS! Try again? (y/n)"
    when "Human 1"  then puts "You WIN! Try again? (y/n)"
    else puts "#{last_player.name} WINS! Try again? (y/n)"
    end
    game.try_again
  end
end
