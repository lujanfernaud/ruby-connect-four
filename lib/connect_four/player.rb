class Player
  attr_accessor :name
  attr_reader   :mark

  def initialize(name:, mark:)
    @name = name
    @mark = mark
  end

  def throw(column, board)
    return board.the_column_is_full(column, self) unless
      board.column_available?(column.to_i)

    board.position_mark_in_column(column.to_i, self)
  end
end
