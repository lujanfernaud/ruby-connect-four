require "spec_helper"

describe Board do
  before do
    @game   = Game.new
    @board  = Board.new(@game)
    @player = @game.human1
  end

  it "has a grid" do
    raise unless @board.grid
  end

  describe "#print_board" do
    it "exists" do
      expect(@board).to respond_to(:print_board)
    end
  end

  describe "#position_mark_in_column" do
    it "exists" do
      expect(@board).to respond_to(:position_mark_in_column)
    end

    it "takes column and player as arguments" do
      expect { @board.position_mark_in_column(2, @player) }.not_to raise_error
    end

    it "checks what position is available in the column and puts mark" do
      @board.grid[3][1] = "X"
      @board.position_mark_in_column(2, @player)
      expect(@board.grid[2][1]).to eql("X")
    end
  end

  describe "#position_available?" do
    before do
      @board.grid = [["X", "-", "-", "-"],
                     ["O", "-", "O", "O"],
                     ["O", "X", "X", "X"],
                     ["O", "X", "O", "X"]]
    end

    it "checks if there's an empty position in the column" do
      column = 2
      expect(@board.position_available?(column)).to eql(true)
      @board.position_available?(column)
    end

    it "checks if there's an empty position in the column" do
      column = 1
      expect(@board.position_available?(column)).to eql(false)
      @board.position_available?(column)
    end
  end

  describe "#the_position_is_not_available" do
    it "prints board and error message" do
      column = 1
      expect(@board).to receive(:print_board)
      expect(STDOUT).to receive(:puts)
        .with("The column #{column} is full.\n\n")
      @board.the_position_is_not_available(column)
    end
  end

  describe "#reset" do
    it "resets board" do
      @board.grid = [["X", "X", "O", "-"],
                     ["O", "X", "O", "O"],
                     ["O", "X", "X", "X"],
                     ["O", "X", "O", "X"]]
      new_grid    = [["-", "-", "-", "-"],
                     ["-", "-", "-", "-"],
                     ["-", "-", "-", "-"],
                     ["-", "-", "-", "-"]]
      @board.reset
      expect(@board.grid).to match(new_grid)
    end
  end
end