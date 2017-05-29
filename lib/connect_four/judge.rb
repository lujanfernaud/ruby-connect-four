class Judge
  attr_reader :game, :board

  def initialize(game, board)
    @game  = game
    @board = board
  end

  def check_for_winner(last_player)
    check_rows(last_player)
    check_columns(last_player)
    check_diagonals(last_player)

    finish_game if there_is_no_winner?
  end

  private

  def check_rows(last_player)
    board.grid.each do |row|
      row.each.with_index do |_mark, index|
        break if index == 4
        slice = row.slice(index...index + 4)
        the_winner_is(last_player) if
          slice.all? { |mark| mark == last_player.mark }
      end
    end
  end

  def check_columns(last_player)
    7.times do |col|
      column = board.grid.map { |row| row[col] }

      column.each.with_index do |_mark, index|
        break if index == 3
        slice = column.slice(index...index + 4)
        return the_winner_is(last_player) if
          slice.all? { |mark| mark == last_player.mark }
      end
    end
  end

  def check_diagonals(last_player)
    board.diagonals.each do |side|
      marks = build_diagonals_from(side)

      marks.each.with_index do |_mark, index|
        break if index == marks.length - 5
        slice = marks.slice(index...index + 4)
        return the_winner_is(last_player) if
          slice.all? { |mark| mark == last_player.mark }
      end
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
      y  = case side
           when :left  then y - 1
           when :right then y + 1
           end
      x += 1
    end
  end

  def finish_game
    board.print_board
    puts "There's no winner. Try again? (y/n)"
    game.try_again
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
    game.try_again
  end
end
