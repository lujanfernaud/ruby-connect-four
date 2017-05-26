require "spec_helper"

describe Player do
  before :all do
    @game   = Game.new
    @player = @game.human1
    @player.name = "Matz"
    @player.mark = "X"
  end

  describe "attributes" do
    it "has a name" do
      expect(@player.name).to eql("Matz")
    end

    it "has a mark" do
      expect(@player.mark).to eql("X")
    end

    it "knows about board" do
      expect(@player).to respond_to(:board)
    end
  end

  describe "#throw" do
    it "exists" do
      expect(@player).to respond_to(:throw)
    end

    it "accepts one number as an argument" do
      expect { @player.throw(2) }.not_to raise_error
    end

    it "places mark on the grid" do
      @player.board.grid[3][1] = "X"
      @player.board.grid[2][1] = "X"
      @player.board.position_mark_in_column(2, @player)
      expect(@player.board.grid[1][1]).to eql("X")
    end
  end
end
