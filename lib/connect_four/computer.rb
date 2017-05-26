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
    3.times do |i|
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
      array = []
      row.each { |column| array << column }

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      next if empty_slots.zero? && index < 3
      return false if empty_slots.zero?

      if computer_marks == 3 && human_marks.zero?
        return array.index("-") + 1
      end

      if computer_marks == 2 && human_marks.zero? && iteration == 1
        return array.index("-") + 1
      end

      if computer_marks == 1 && human_marks.zero? && iteration == 2
        return array.index("-") + 1
      end

      next if computer_mark_or_no_human_mark(array) && index < 3
      return false if computer_mark_or_no_human_mark(array)
      return false if iteration.zero? && human_marks < 2

      return array.index("-") + 1
    end
  end

  def check_columns(iteration:)
    4.times do |column|
      array = []
      board.grid.each.with_index do |_row, index|
        array << board.grid[index][column]
      end

      computer_marks = array.join.count(mark)
      human_marks    = array.join.count(human_mark)
      empty_slots    = array.join.count("-")

      next if empty_slots.zero?

      if computer_marks == 3 && human_marks.zero?
        return column + 1
      end

      if computer_marks == 2 && human_marks.zero? && iteration == 1
        return column + 1
      end

      if computer_marks == 1 && human_marks.zero? && iteration == 2
        return column + 1
      end

      next if computer_mark_or_no_human_mark(array) && column < 3
      return false if computer_mark_or_no_human_mark(array)
      return false if iteration.zero? && human_marks < 2

      return column + 1
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

    return diagonal_attack(computer_marks, column, iteration) if human_marks.zero?
    return diagonal_defend(human_marks, column) if computer_marks.zero?
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

    return diagonal_attack(computer_marks, column, iteration) if human_marks.zero?
    return diagonal_defend(human_marks, column) if computer_marks.zero?
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

  def computer_mark_or_no_human_mark(array)
    computer_mark = array.any?  { |mark| mark == self.mark }
    no_human_mark = array.none? { |mark| mark == human_mark }
    computer_mark || no_human_mark
  end

  def choose_random_column
    rows    = [*0..3]
    columns = [*0..3]

    loop do
      row      = rows.sample
      column   = columns.sample
      location = board.grid[row][column]
      return column + 1 if location == "-"
    end
  end
end
