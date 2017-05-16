require "./spec/spec_helper"
require "./lib/connect_four"

describe Player do
  it "has a name" do
    raise unless Player.new(name: "Matz", mark: "X").name == "Matz"
  end

  it "has a mark" do
    raise unless Player.new(name: "Matz", mark: "X").mark == "X"
  end
end

describe Computer do
  it "has a name" do
    raise unless Computer.new(mark: "O").name == "Computer"
  end

  it "has a mark" do
    raise unless Computer.new(mark: "O").mark == "O"
  end
end

describe Board do
  it "has a grid" do
    raise unless Board.new.grid
  end
end
