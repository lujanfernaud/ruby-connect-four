class Board
  attr_accessor :grid
  attr_reader   :reset, :game

  def initialize(game)
    @game = game
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
    puts "   #################"
    puts "   #               #"
    puts "   #   CONNECT 4   #"
    puts "   #               #"
    puts "   #################"
    puts "\n"
    puts "     1 | 2 | 3 | 4 "
    puts "   -----------------"
    puts "   | #{grid[0][0]}   #{grid[0][1]}   #{grid[0][2]}   #{grid[0][3]} |"
    puts "   ----------------"
    puts "   | #{grid[1][0]}   #{grid[1][1]}   #{grid[1][2]}   #{grid[1][3]} |"
    puts "   ----------------"
    puts "   | #{grid[2][0]}   #{grid[2][1]}   #{grid[2][2]}   #{grid[2][3]} |"
    puts "   ----------------"
    puts "   | #{grid[3][0]}   #{grid[3][1]}   #{grid[3][2]}   #{grid[3][3]} |"
    puts "\n"
  end

  def position_mark_in_column(column, player)
    unless column_available?(column)
      the_column_is_not_available(column)
      player.throw(game.introduce_column(player, print_board: false))
    end

    grid.reverse.each do |row|
      next if row[column - 1] != "-"
      row[column - 1] = player.mark
      break
    end
  end

  def column_available?(column)
    grid.map { |row| row[column - 1] }.any? { |slot| slot == "-" }
  end

  def the_column_is_not_available(column)
    print_board
    puts "The column #{column} is full.\n\n"
  end
end
