require "./spec/spec_helper"
require "./lib/connect_four"

describe Player do
  it "has a name" do
    raise unless Player.new(name: "Matz", mark: "X").name == "Matz"
  end

  it "has a mark" do
    raise unless Player.new(name: "Matz", mark: "X").mark == "X"
  end

  it "knows about board" do
    raise unless Player.new(name: "Matz", mark: "X").board
  end
end

describe Computer do
  it "has a name" do
    raise unless Computer.new(mark: "O").name == "Computer"
  end

  it "has a mark" do
    raise unless Computer.new(mark: "O").mark == "O"
  end

  it "knows about board" do
    raise unless Computer.new(mark: "O").board
  end
end

describe Board do
  it "has a grid" do
    raise unless Board.new.grid
  end

  describe "#print" do
    it "exists" do
      expect(Board.new).to respond_to(:print)
    end
  end
end

describe Game do
  it "has a board" do
    raise unless Game.new.board
  end

  it "has number of players" do
    raise unless Game.new.players
  end

  it "has one player by default" do
    expect(Game.new.players).to eql(1)
  end

  it "has human players" do
    raise unless Game.new.human1
    raise unless Game.new.human2
  end

  it "has a computer player" do
    raise unless Game.new.computer
  end

  it "sends board to all players" do
    raise unless Game.new.human1.board.grid
    raise unless Game.new.human2.board.grid
    raise unless Game.new.computer.board.grid
  end

  describe "#setup" do
    it "exists" do
      expect(Game.new).to respond_to(:setup)
    end
  end
end
