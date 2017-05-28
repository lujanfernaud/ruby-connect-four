class Computer < Player
  attr_accessor :name
  attr_reader   :mark, :board, :human_mark

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
    board.position_mark_in_column(choose_column, self)
  end

  private

  # TO-DO: Check if the position below the one selected is empty.
  def choose_column
    3.times do |i|
      matches = []
      matches << check_rows(iteration: i)
      matches << check_columns(iteration: i)
      matches << check_diagonals(iteration: i)

      good_match = proc { |match| match && board.column_available?(match) }
      column = matches.select(&good_match).first
      return column if column
    end

    choose_random_column
  end

  def check_rows(iteration:)
    matches = { human: {}, computer: {} }
    empty   = proc { |slot| slot == "-" }

    board.grid.each.with_index do |row, index|
      empty_slots = row.join.count("-")

      if empty_slots == 7
        case index
        when 0..4 then next
        when 5    then return false
        end
      end

      1.upto(3) do |count|
        human    = Array.new(count) { "X" }
        computer = Array.new(count) { "O" }
        players  = { human: human, computer: computer }

        players.each do |player_name, player_marks|
          idx = row.each_cons(count).map { |m| m == player_marks }.index(true)
          next if idx.nil?

          case count
          when 1
            next if iteration < 2

            if idx > 0 && [row[idx - 1], row[idx + 1]].all?(&empty)
              matches[player_name][count] = [idx - 1, idx + 1].sample

            elsif idx > 1 && row[(idx - 2)..(idx - 1)].all?(&empty)

              matches[player_name][count] = idx - count

            elsif row[(idx + count)..(idx + (count + 1))].all?(&empty)

              matches[player_name][count] = idx + count
            end

          when 2
            next if iteration.zero?

            if idx > 0 && [row[idx - 1], row[idx + 2]].all?(&empty)
              matches[player_name][count] = [idx - 1, idx + 2].sample

            elsif idx > 1 && row[(idx - 2)..(idx - 1)].all?(&empty) ||
                  row[idx - 1] == "-" && row[idx - 2] == "X"

              matches[player_name][count] = idx - (count - 1)

            elsif row[(idx + count)..(idx + (count + 1))].all?(&empty) ||
                  row[idx + count] == "-" && row[idx + count + 1] == "X"

              matches[player_name][count] = idx + count

            end

          when 3

            if idx > 0 && [row[idx - 1], row[idx + 3]].all?(&empty)
              matches[player_name][count] = [idx - 1, idx + 3].sample
            elsif idx > 1 && row[idx - 1] == "-"
              matches[player_name][count] = idx - 1
            elsif row[idx + 3] == "-"
              matches[player_name][count] = idx + 3
            end
          end
        end
      end

      next if index < 5

      columns = [matches[:computer][3], matches[:human][3],
                 matches[:computer][2], matches[:human][2], matches[:human][1]]
      column  = columns.compact.first

      return column + 1 if column
      return false
    end
  end

  def check_columns(iteration:)
    matches = { human: {}, computer: {} }

    7.times do |col|
      array = board.grid.map.with_index { |_row, index| board.grid[index][col] }
      array.reverse!

      empty_slots = array.join.count("-")
      next if empty_slots.zero? || empty_slots == 7

      2.upto(3) do |count|
        human    = Array.new(count) { "X" }
        computer = Array.new(count) { "O" }
        players  = { human: human, computer: computer }

        players.each do |player_name, player_marks|
          idx = array.each_cons(count).map { |m| m == player_marks }.index(true)
          next if idx.nil?
          case count
          when 2
            next if iteration.zero?
            matches[player_name][count] = col if array[idx + count] == "-"
          when 3
            matches[player_name][count] = col if array[idx + count] == "-"
          end
        end
      end

      next if col < 6

      columns = [matches[:computer][3], matches[:human][3],
                 matches[:human][2], matches[:computer][2]]
      column  = columns.compact.first

      return column + 1 if column
      return false
    end
  end

  def check_diagonals(iteration:)
    matches = { human: {}, computer: {} }

    board.diagonals.each do |side|
      diagonals = build_diagonals_from(side)

      diagonals.each.with_index do |diagonal, index|
        col   = diagonal[0]
        marks = diagonal[1..-1]
        marks.reverse! if side[:side] == :right

        empty_slots = marks.join.count("-")

        if empty_slots.zero?
          case index
          when 0..4 then next
          when 5    then return false
          end
        end

        2.upto(3) do |count|
          human    = Array.new(count) { "X" }
          computer = Array.new(count) { "O" }
          players  = { human: human, computer: computer }

          players.each do |player_name, player_marks|
            idx = marks.each_cons(count).map { |m| m == player_marks }.index(true)
            next if idx.nil?
            case count
            when 2
              next if iteration.zero?
              matches[player_name][count] = col + (idx + count) if marks[idx + count] == "-"
            when 3
              matches[player_name][count] = col + (idx + count) if marks[idx + count] == "-"
            end
          end
        end
      end

      next if side[:side] == :left

      return false if matches[:human].empty? && matches[:computer].empty?

      columns = [matches[:computer][3], matches[:human][3],
                 matches[:human][2], matches[:computer][2]]
      column  = columns.compact.first

      return column + 1 if column
      return false
    end
  end

  def build_diagonals_from(side)
    diagonals = []
    side.each_value do |pair|
      next if pair == :left || pair == :right

      y = pair[:start][:y]
      x = pair[:start][:x]

      add_diagonal(pair, side[:side], y, x, diagonals)
    end
    diagonals
  end

  def add_diagonal(diagonal, side, y, x, diagonals)
    start    = diagonal[:start][:x]
    finish   = diagonal[:finish][:x]
    diagonal = [start]

    (start..finish).each do
      diagonal << board.grid[y][x]
      y  = case side
           when :left  then y - 1
           when :right then y + 1
           end
      x += 1
    end
    diagonals << diagonal
  end

  def choose_random_column
    rows    = [*0..5]
    columns = [*0..6]

    loop do
      row      = rows.sample
      column   = columns.sample
      location = board.grid[row][column]
      return column + 1 if location == "-"
    end
  end
end
