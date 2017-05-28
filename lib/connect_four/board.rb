class Board
  attr_accessor :grid
  attr_reader   :diagonals, :reset, :game

  DIAGONALS = [{ side:       :left,
                 diagonal1: { start: { y: 3, x: 0 }, finish: { y: 0, x: 3 } },
                 diagonal2: { start: { y: 4, x: 0 }, finish: { y: 0, x: 4 } },
                 diagonal3: { start: { y: 5, x: 0 }, finish: { y: 0, x: 5 } },
                 diagonal4: { start: { y: 5, x: 1 }, finish: { y: 0, x: 6 } },
                 diagonal5: { start: { y: 5, x: 2 }, finish: { y: 1, x: 6 } },
                 diagonal6: { start: { y: 5, x: 3 }, finish: { y: 2, x: 6 } } },
               { side:      :right,
                 diagonal1: { start: { y: 2, x: 0 }, finish: { y: 5, x: 3 } },
                 diagonal2: { start: { y: 1, x: 0 }, finish: { y: 5, x: 4 } },
                 diagonal3: { start: { y: 0, x: 0 }, finish: { y: 5, x: 5 } },
                 diagonal4: { start: { y: 0, x: 1 }, finish: { y: 5, x: 6 } },
                 diagonal5: { start: { y: 0, x: 2 }, finish: { y: 4, x: 6 } },
                 diagonal6: { start: { y: 0, x: 3 }, finish: { y: 3, x: 6 } } }]
              .freeze

  def initialize(game)
    @game = game
    create_grid
    @diagonals = DIAGONALS
  end

  def print_board
    system "clear" or system "cls"
    puts "\n"
    puts "   #############################"
    puts "   #                           #"
    puts "   #         CONNECT 4         #"
    puts "   #                           #"
    puts "   #############################"
    puts "\n"
    puts "     1 | 2 | 3 | 4 | 5 | 6 | 7"
    puts "   -----------------------------"
    puts "   | #{grid[0][0]}   #{grid[0][1]}   #{grid[0][2]}   #{grid[0][3]}   #{grid[0][4]}   #{grid[0][5]}   #{grid[0][6]} |"
    puts "   -----------------------------"
    puts "   | #{grid[1][0]}   #{grid[1][1]}   #{grid[1][2]}   #{grid[1][3]}   #{grid[1][4]}   #{grid[1][5]}   #{grid[1][6]} |"
    puts "   -----------------------------"
    puts "   | #{grid[2][0]}   #{grid[2][1]}   #{grid[2][2]}   #{grid[2][3]}   #{grid[2][4]}   #{grid[2][5]}   #{grid[2][6]} |"
    puts "   -----------------------------"
    puts "   | #{grid[3][0]}   #{grid[3][1]}   #{grid[3][2]}   #{grid[3][3]}   #{grid[3][4]}   #{grid[3][5]}   #{grid[3][6]} |"
    puts "   -----------------------------"
    puts "   | #{grid[4][0]}   #{grid[4][1]}   #{grid[4][2]}   #{grid[4][3]}   #{grid[4][4]}   #{grid[4][5]}   #{grid[4][6]} |"
    puts "   -----------------------------"
    puts "   | #{grid[5][0]}   #{grid[5][1]}   #{grid[5][2]}   #{grid[5][3]}   #{grid[5][4]}   #{grid[5][5]}   #{grid[5][6]} |"
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

  def reset
    create_grid
  end

  private

  def create_grid
    @grid = Array.new(6) { Array.new(7) { "-" } }
  end
end
