require "pry"

class Player
  attr_accessor :name
  attr_reader   :board, :mark

  def initialize(name:, mark:, board: [])
    @name  = name
    @mark  = mark
    @board = board
  end

  def throw(column)
    return board.the_column_is_full(column, self) unless
      board.column_available?(column.to_i)

    board.position_mark_in_column(column.to_i, self)
  end
end
