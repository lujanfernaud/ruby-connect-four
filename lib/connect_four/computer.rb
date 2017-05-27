require "pry"

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

  def choose_column
    3.times do |i|
      matches = []
      matches << check_rows(iteration: i)
      matches << check_columns(iteration: i)
      # matches << check_diagonals

      good_match = proc { |match| match && board.column_available?(match) }
      column = matches.select(&good_match).first
      return column if column
    end

    choose_random_column
  end

  def check_rows(iteration:)
    matches = { human: {}, computer: {} }

    board.grid.each.with_index do |row, index|
      empty_slots = row.join.count("-")

      if empty_slots == 7
        case index
        when 0..4 then next
        when 5    then return false
        end
      end

      1.upto(3) do |i|
        human    = Array.new(i) { "X" }
        computer = Array.new(i) { "O" }
        players  = { human: human, computer: computer }

        players.each do |player_name, player_marks|
          idx = row.each_cons(i).map { |m| m == player_marks }.index(true)
          next if idx.nil?

          case i
          when 1
            next if iteration.zero?

            if idx > 0 && row[idx - 1] == "-" && row[idx + 1] == "-"
              matches[player_name][i] = [idx - 1, idx + 1].sample
            elsif idx > 1 && row[(idx - 2)..(idx - 1)].all? { |slot| slot == "-" }
              matches[player_name][i] = idx - i
            elsif row[(idx + i)..(idx + (i + 1))].all? { |slot| slot == "-" }
              matches[player_name][i] = idx + i
            end
          when 2
            next if iteration.zero?

            if idx > 0 && row[idx - 1] == "-" && row[idx + 2] == "-"
              matches[player_name][i] = [idx - 1, idx + 2].sample
            elsif idx > 1 && row[(idx - 2)..(idx - 1)].all? { |slot| slot == "-" } ||
                  row[idx - 1] == "-" && row[idx - 2] == "X"
              matches[player_name][i] = idx - (i - 1)
            elsif row[(idx + i)..(idx + (i + 1))].all? { |slot| slot == "-" } ||
                  row[idx + i] == "-" && row[idx + i + 1] == "X"
              matches[player_name][i] = idx + i
            end
          when 3

            if idx > 0 && row[idx - 1] == "-" && row[idx + 3] == "-"
              matches[player_name][i] = [idx - 1, idx + 3].sample
            elsif idx > 1 && row[idx - 1] == "-"
              matches[player_name][i] = idx - 1
            elsif row[idx + 3] == "-"
              matches[player_name][i] = idx + 3
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

      2.upto(3) do |i|
        human    = Array.new(i) { "X" }
        computer = Array.new(i) { "O" }
        players  = { human: human, computer: computer }

        players.each do |player_name, player_marks|
          idx = array.each_cons(i).map { |m| m == player_marks }.index(true)
          next if idx.nil?
          case i
          when 2
            next if iteration.zero?
            matches[player_name][i] = col if array[idx + i] == "-"
          when 3
            matches[player_name][i] = col if array[idx + i] == "-"
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

  def attack_or_defend(computer_marks, human_marks, column, iteration)
    attack = attack(computer_marks, column, iteration)
    return attack if attack && human_marks <= 3
    defend = defend(human_marks, column, iteration)
    return defend if defend && computer_marks <= 3
  end

  def attack(computer_marks, column, iteration)
    case computer_marks
    when 3 then column
    when 2 then column if iteration == 1
    when 1 then column if iteration == 2
    else false
    end
  end

  def defend(human_marks, column, iteration)
    case human_marks
    when 2..3 then column
    when 1
      if iteration.zero?
        false
      else
        column
      end
    else false
    end
  end

  def check_diagonals
    2.times do |iteration|
      column = diagonal_from_left_bottom(iteration)
      return column if column
      column = diagonal_from_right_bottom(iteration)
      return column if column
    end

    false
  end

  def diagonal_from_left_bottom(iteration)
    array = build_diagonal_left_array

    computer_marks = array.join.count(mark)
    human_marks    = array.join.count(human_mark)
    empty_slots    = array.join.count("-")
    column         = array.index("-")

    return false if empty_slots.zero?
    return false unless supportive_column_left(column)

    return diagonal_attack(computer_marks, column, iteration) if human_marks <= 3
    return diagonal_defend(human_marks, column) if computer_marks <= 3
  end

  def build_diagonal_left_array
    array  = []
    column = 0
    board.grid.reverse.map.with_index do |_row, index|
      array << board.grid.reverse[index][column]
      column += 1
    end
    array
  end

  def supportive_column_left(column)
    array = []
    board.grid.reverse.each.with_index do |_row, index|
      array << board.grid.reverse[index][column]
    end
    column == array.index("-")
  end

  def diagonal_from_right_bottom(iteration)
    array = build_diagonal_right_array

    computer_marks = array.join.count(mark)
    human_marks    = array.join.count(human_mark)
    empty_slots    = array.join.count("-")
    column         = array.count { |v| v == "-" } - 1

    return false if empty_slots.zero?
    return false unless supportive_column_right(column)

    return diagonal_attack(computer_marks, column, iteration) if human_marks <= 3
    return diagonal_defend(human_marks, column) if computer_marks <= 3
  end

  def build_diagonal_right_array
    array  = []
    column = 0
    board.grid.each.with_index do |_row, index|
      array << board.grid[index][column]
      column += 1
    end
    array
  end

  def supportive_column_right(column)
    array = []
    board.grid.each.with_index do |_row, index|
      array << board.grid[index][column]
    end

    column == array.count { |v| v == "-" } - 1
  end

  def diagonal_attack(computer_marks, column, iteration)
    case computer_marks
    when 3 then column + 1
    when 2 then column + 1 if iteration == 1
    else false
    end
  end

  def diagonal_defend(human_marks, column)
    case human_marks
    when 2..3 then column + 1
    else false
    end
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
