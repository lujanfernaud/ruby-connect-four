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
