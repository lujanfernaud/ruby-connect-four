class Player
  attr_accessor :name, :mark
  attr_reader   :board

  def initialize(name:, mark:, board: [])
    @name  = name
    @mark  = mark
    @board = board
  end

  def throw(column)
    board.position_mark_in_column(column.to_i, self)
  end
end
