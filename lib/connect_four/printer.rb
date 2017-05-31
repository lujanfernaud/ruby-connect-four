class Printer
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def print_board
    system "clear" or system "cls"
    puts "\n"
    print_game_title
    puts "\n"
    print_game_grid
    puts "\n"
  end

  private

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
    board.grid[row].each.with_index do |_column, column_index|
      print "   | " if column_index.zero?
      print "   "   if (1..6).cover?(column_index)

      print "#{board.grid[row][column_index]}"

      print " |\n" if column_index == 6
    end
  end
end
