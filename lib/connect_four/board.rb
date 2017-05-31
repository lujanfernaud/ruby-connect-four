require_relative "diagonals"
require_relative "printer"

class Board
  include Diagonals

  attr_accessor :grid
  attr_reader   :game, :diagonals, :printer

  def initialize(game)
    create_grid
    @game      = game
    @diagonals = DIAGONALS
    @printer   = Printer.new(self)
  end

  def place_mark_in_column(column, player)
    return the_column_is_full(column, player) unless
      column_available?(column)

    grid.reverse.each do |row|
      next unless row[column] == "-"
      row[column] = player.mark
      break
    end
  end

  def column_available?(column)
    grid.map { |row| row[column] }.any? { |slot| slot == "-" }
  end

  def the_column_is_full(column, player)
    printer.print_board
    puts "The column #{column + 1} is full.\n\n"
    game.retry_turn(player)
  end

  def reset
    create_grid
  end

  private

  def create_grid
    @grid = Array.new(6) { Array.new(7) { "-" } }
  end
end
