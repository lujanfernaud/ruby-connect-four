require "spec_helper"

describe Player do
  let(:player1) { Player.new(name: "Sandi", mark: "X") }
  let(:player2) { Player.new(name: "Matz", mark: "O") }
  let(:players) { [player1, player2] }
  let(:game)    { Game.new(players) }
  let(:board)   { game.board }

  describe "attributes" do
    it "has a name" do
      expect(player1.name).to eql("Sandi")
    end

    it "allows reading and writing for :name" do
      expect(player2.name).to eql("Matz")
    end

    it "has a mark" do
      expect(player1.mark).to eql("X")
    end
  end

  describe "#throw" do
    it "places mark on the grid" do
      board.grid[5][1] = "X"
      board.grid[4][1] = "X"
      player1.throw(2, board)
      expect(board.grid[3][1]).to eql("X")
    end

    it "calls board.the_column_is_full" do
      board.grid[5][1] = "X"
      board.grid[4][1] = "X"
      board.grid[3][1] = "O"
      board.grid[2][1] = "X"
      board.grid[1][1] = "X"
      board.grid[0][1] = "O"
      expect(board).to receive(:the_column_is_full).with(2, player2)
      player2.throw(2, board)
    end
  end
end
