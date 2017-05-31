require "spec_helper"

describe Player do
  before do
    @game   = Game.new
    @player = @game.human1
    @player.name = "Matz"
  end

  describe "attributes" do
    it "has a name" do
      expect(@player.name).to eql("Matz")
    end

    it "allows reading and writing for :name" do
      @player.name = "Sandi"
      expect(@player.name).to eql("Sandi")
    end

    it "has a mark" do
      expect(@player.mark).to eql("X")
    end

    it "knows about board" do
      expect(@player).to respond_to(:board)
    end
  end

  describe "#throw" do
    it "places mark on the grid" do
      @player.board.grid[5][1] = "X"
      @player.board.grid[4][1] = "X"
      @player.throw(2)
      expect(@player.board.grid[3][1]).to eql("X")
    end

    it "calls board.the_column_is_full" do
      @player.board.grid[5][1] = "X"
      @player.board.grid[4][1] = "X"
      @player.board.grid[3][1] = "O"
      @player.board.grid[2][1] = "X"
      @player.board.grid[1][1] = "X"
      @player.board.grid[0][1] = "O"
      expect(@player.board).to receive(:the_column_is_full).with(2, @player)
      @player.throw(2)
    end
  end
end
