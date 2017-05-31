require "spec_helper"

describe Board do
  before do
    @game  = Game.new
    @board = Board.new(@game)
    @board.grid = [["-", "-", "-", "-", "-", "-", "O"],
                   ["-", "-", "-", "-", "-", "-", "X"],
                   ["-", "-", "-", "-", "-", "-", "O"],
                   ["-", "-", "-", "-", "-", "-", "X"],
                   ["-", "-", "-", "-", "-", "-", "O"],
                   ["-", "X", "O", "-", "-", "O", "X"]]
    @player = @game.human1
  end

  describe "attributes" do
    it "knows about :game" do
      raise unless @board.game
    end

    it "allows reading and writing for :grid" do
      @board.grid[0][1] = "X"
      expect(@board.grid[0][1]).to eql("X")
      @board.grid[0][1] = "-"
    end

    it "allows reading for :diagonals" do
      raise unless @board.diagonals
    end
  end

  describe "#print_board" do
    it "clears screen and puts board" do
      expect(@board).to receive(:system).with("clear")
      expect(@board).to receive(:system).with("cls")
      expect(STDOUT).to receive(:puts).exactly(21).times
      @board.print_board
    end
  end

  describe "#position_mark_in_column" do
    it "takes column and player as arguments" do
      expect { @board.position_mark_in_column(2, @player) }.not_to raise_error
    end

    it "checks what position is available in the column and places mark" do
      @board.grid[5][1] = "X"
      @board.position_mark_in_column(2, @player)
      expect(@board.grid[4][1]).to eql("X")
    end
  end

  describe "#column_available?" do
    it "checks and returns 'true'" do
      column = 2
      expect(@board.column_available?(column)).to eql(true)
      @board.column_available?(column)
    end

    it "checks and returns 'false'" do
      column = 7
      expect(@board.column_available?(column)).to eql(false)
      @board.column_available?(column)
    end
  end

  describe "#the_column_is_full" do
    it "prints board, error message and calls game.retry_turn" do
      column = 1
      expect(@board).to receive(:print_board)
      expect(STDOUT).to receive(:puts)
        .with("The column #{column} is full.\n\n")
      expect(@game).to receive(:retry_turn).with(@player)
      @board.the_column_is_full(column, @player)
    end
  end

  describe "#reset" do
    it "resets board" do
      new_grid = Array.new(6) { Array.new(7) { "-" } }
      @board.reset
      expect(@board.grid).to match(new_grid)
    end
  end
end
