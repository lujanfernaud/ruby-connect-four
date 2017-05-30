class Computer
  attr_accessor :name
  attr_reader   :mark, :board, :human

  def initialize(mark:, human:, board: [])
    @name  = "Computer"
    @mark  = mark
    @human = human
    @board = board
  end

  def throw
    board.print_board
    puts "Computer turn..."
    sleep rand(1..2) * 0.5
    board.position_mark_in_column(choose_column, self)
  end

  private

  def choose_column
    matches = []
    matches << check_rows
    matches << check_columns
    matches << check_diagonals

    good_match = proc { |match| match && board.column_available?(match) }
    column     = matches.select(&good_match).first

    return column + 1 if column
    choose_random_column
  end

  def check_rows
    matches = { human: {}, computer: {} }

    board.grid.each.with_index do |row, row_index|
      get_row_matches(row, row_index, matches)

      next if row_index < 5

      columns = parse_matches(matches)
      column  = columns.compact.first

      return column if column
      return false
    end
  end

  def get_row_matches(row, row_index, matches)
    get_row_human_match(row, row_index, matches)
    get_row_computer_match(row, row_index, matches)
  end

  def get_row_human_match(row, row_index, matches)
    human_data = parse_row_marks(human, row)
    return false unless human_data

    count        = human_data[0]
    regexp       = human_data[1]
    empty_index  = human_data[2]
    human_index  = get_index(row, regexp)
    column       = human_index + empty_index

    return false if position_below_empty?(row_index, column)
    matches[:human][count] = column
  end

  def get_row_computer_match(row, row_index, matches)
    computer_data = parse_row_marks(self, row)
    return false unless computer_data

    count          = computer_data[0]
    regexp         = computer_data[1]
    empty_index    = computer_data[2]
    computer_index = get_index(row, regexp)
    column         = computer_index + empty_index

    return false if position_below_empty?(row_index, column)
    matches[:computer][count] = column
  end

  def parse_row_marks(player, line)
    regexps_for_row(player).each do |regexp|
      match = line.join.match(regexp)
      next unless match
      marks_count = match[0].count(player.mark)
      empty_index = match[0] =~ /\-/
      return [marks_count, regexp, empty_index] if marks_count
    end
    false
  end

  def regexps(player)
    [/#{player.mark}#{player.mark}#{player.mark}\-/,  # "XXX-"
     /#{player.mark}#{player.mark}\-\-/]              # "XX--"
  end

  def regexps_for_row(player)
    [regexps_three_marks_for_row(player),
     regexps_two_marks_for_row(player)].flatten
  end

  def regexps_three_marks_for_row(player)
    [/#{player.mark}#{player.mark}\-#{player.mark}/,  # "XX-X"
     /#{player.mark}\-#{player.mark}#{player.mark}/,  # "X-XX"
     /#{player.mark}#{player.mark}#{player.mark}\-/,  # "XXX-"
     /\-#{player.mark}#{player.mark}#{player.mark}/]  # "-XXX"
  end

  def regexps_two_marks_for_row(player)
    [/#{player.mark}\-\-#{player.mark}/,              # "X--X"
     /\-#{player.mark}\-#{player.mark}/,              # "-X-X"
     /#{player.mark}\-#{player.mark}\-/,              # "X-X-"
     /#{player.mark}#{player.mark}\-\-/,              # "XX--"
     /\-#{player.mark}#{player.mark}\-/,              # "-XX-"
     /\-\-#{player.mark}#{player.mark}/]              # "--XX"
  end

  def check_columns
    matches = { human: {}, computer: {} }

    7.times do |col|
      array = build_column_array(col)

      get_matches(array, col, matches)

      next if col < 6

      columns = parse_matches(matches)
      column  = columns.compact.first

      return column if column
      return false
    end
  end

  def build_column_array(col)
    board.grid.map.with_index { |_row, index| board.grid[index][col] }.reverse
  end

  def get_matches(line, column, matches)
    get_human_match(line, column, matches)
    get_computer_match(line, column, matches)
  end

  def get_human_match(line, column, matches)
    count = count_marks(human, line)
    return false unless count
    matches[:human][count] = column
  end

  def get_computer_match(line, column, matches)
    count = count_marks(self, line)
    return false unless count
    matches[:computer][count] = column
  end

  def count_marks(player, line)
    regexps(player).each do |regexp|
      match = line.join.match(regexp)
      next unless match
      marks_count = match[0].count(player.mark)
      return marks_count if marks_count
    end
    false
  end

  def check_diagonals
    matches = { human: {}, computer: {} }

    board.diagonals.each do |side|
      diagonals = build_diagonals_from(side)

      diagonals.each do |diagonal|
        col   = diagonal[0]
        row   = diagonal[1]
        marks = diagonal[2..-1]
        marks.reverse! if side[:side] == :right

        get_diagonal_matches(marks, col, row, matches, side[:side])
      end
      next if side[:side] == :left

      columns = parse_matches(matches)
      column  = columns.compact.first

      return column if column
      return false
    end
  end

  def get_diagonal_matches(line, column, row, matches, side)
    get_diagonal_human_match(line, column, row, matches, side)
    get_diagonal_computer_match(line, column, row, matches, side)
  end

  def get_diagonal_human_match(line, col, row, matches, side)
    human_data = parse_diagonal_marks(human, line)
    return false unless human_data

    count       = human_data[0]
    regexp      = human_data[1]
    human_index = get_index(line, regexp)
    row_index   = row - count if side == :left
    row_index   = row - count - human_index if side == :right
    column      = col + count + human_index if side == :left
    column      = col - count - human_index if side == :right

    return false if position_below_empty?(row_index, column)
    matches[:human][count] = column unless matches[:human][count]
  end

  def get_diagonal_computer_match(line, col, row, matches, side)
    computer_data = parse_diagonal_marks(self, line)
    return false unless computer_data

    count          = computer_data[0]
    regexp         = computer_data[1]
    computer_index = get_index(line, regexp)
    row_index      = row - count if side == :left
    row_index      = row - count - computer_index if side == :right
    column         = col + count + computer_index if side == :left
    column         = col - count - computer_index if side == :right

    return false if position_below_empty?(row_index, column)
    matches[:computer][count] = column unless matches[:computer][count]
  end

  def parse_diagonal_marks(player, line)
    regexps_for_row(player).each do |regexp|
      match = line.join.match(regexp)
      next unless match
      marks_count = match[0].count(player.mark)
      return [marks_count, regexp] if marks_count
    end
    false
  end

  def build_diagonals_from(side)
    case side[:side]
    when :left  then build_diagonals_from_left(side)
    when :right then build_diagonals_from_right(side)
    end
  end

  def build_diagonals_from_left(side)
    diagonals = []
    side.each_value do |pair|
      next if pair == :left || pair == :right

      y = pair[:start][:y]
      x = pair[:start][:x]

      add_diagonal_from_left(pair, y, x, diagonals)
    end
    diagonals
  end

  def build_diagonals_from_right(side)
    diagonals = []
    side.each_value do |pair|
      next if pair == :left || pair == :right

      y = pair[:finish][:y]
      x = pair[:finish][:x]

      add_diagonal_from_right(pair, y, x, diagonals)
    end
    diagonals
  end

  def add_diagonal_from_left(diagonal, y, x, diagonals)
    start    = diagonal[:start][:x]
    finish   = diagonal[:finish][:x]
    row      = diagonal[:start][:y]
    diagonal = [start, row]

    (start..finish).each do
      diagonal << board.grid[y][x]
      y -= 1
      x += 1
    end
    diagonals << diagonal
  end

  def add_diagonal_from_right(diagonal, y, x, diagonals)
    start    = diagonal[:finish][:x]
    finish   = diagonal[:start][:x]
    row      = diagonal[:start][:y]
    diagonal = [finish, row]

    (start..finish).each do
      diagonal << board.grid[y][x]
      y += 1
      x += 1
    end
    diagonals << diagonal
  end

  def get_index(line, regexp)
    line.join =~ regexp
  end

  def position_below_empty?(row, column)
    return false if row == 5
    board.grid[row + 1][column] == "-"
  end

  def parse_matches(matches)
    [matches[:computer][3], matches[:human][3],
     matches[:computer][2], matches[:human][2]]
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
