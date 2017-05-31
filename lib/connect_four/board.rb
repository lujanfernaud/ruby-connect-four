require_relative "diagonals"

class Board
  include Diagonals

  attr_accessor :grid
  attr_reader   :diagonals, :reset, :game

  def initialize(game)
    @game = game
    create_grid
    @diagonals = DIAGONALS
  end

  def print_board
    system "clear" or system "cls"
    puts "\n"
    print_game_title
    puts "\n"
    print_game_grid
    puts "\n"
  end

  def position_mark_in_column(column, player)
    return the_column_is_full(column, player) unless
      column_available?(column)

    grid.reverse.each do |row|
      next unless row[column - 1] == "-"
      row[column - 1] = player.mark
      break
    end
  end

  def column_available?(column)
    grid.map { |row| row[column - 1] }.any? { |slot| slot == "-" }
  end

  def the_column_is_full(column, player)
    print_board
    puts "The column #{column} is full.\n\n"
    game.retry_turn(player)
  end

  def reset
    create_grid
  end

  private

  def create_grid
    @grid = Array.new(6) { Array.new(7) { "-" } }
  end

  def print_game_title
    puts "   #############################"
    puts "   #                           #"
    puts "   #         CONNECT 4         #"
    puts "   #                           #"
    puts "   #############################"
  end

  def print_game_grid
    puts "     1 | 2 | 3 | 4 | 5 | 6 | 7"
    puts "   -----------------------------"
    print_row(0)
    puts "   -----------------------------"
    print_row(1)
    puts "   -----------------------------"
    print_row(2)
    puts "   -----------------------------"
    print_row(3)
    puts "   -----------------------------"
    print_row(4)
    puts "   -----------------------------"
    print_row(5)
  end

  def print_row(row)
    grid[row].each.with_index do |_column, column_index|
      print "   | " if column_index.zero?
      print "   "   if (1..6).cover?(column_index)

      print "#{grid[row][column_index]}"

      print " |\n" if column_index == 6
    end
  end
end
