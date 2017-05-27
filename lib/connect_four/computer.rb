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

  def choose_column
    6.times do |i|
      matches = []
      matches << check_rows(iteration: i)
      matches << check_columns(iteration: i)
      matches << check_diagonals

      good_match = proc { |match| match && board.column_available?(match) }
      column = matches.select(&good_match).first
      return column if column
    end

    choose_random_column
  end

  def check_rows(iteration:)
    board.grid.each.with_index do |row, index|
      array = row

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      if empty_slots.zero?
        case index
        when 0..4 then next
        when 5    then return false
        end
      end

      column = case array.index("X")
               when 0..4 then array.index("X") + 2
               when 5..6 then array.index("X") - 2
               end

      action = attack_or_defend(computer_marks, human_marks, column, iteration)
      return action if action

      next if index < 5
      return false
    end
  end

  def check_columns(iteration:)
    7.times do |col|
      array = board.grid.map.with_index { |_row, index| board.grid[index][col] }

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      next if empty_slots.zero?

      column = col + 1
      action = attack_or_defend(computer_marks, human_marks, column, iteration)
      return action if action

      next if col < 6
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
