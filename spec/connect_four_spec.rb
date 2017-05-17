require "./lib/connect_four"

describe Player do
  before :all do
    @player = Player.new(name: "Matz", mark: "X")
  end

  it "has a name" do
    raise unless @player.name == "Matz"
  end

  it "has a mark" do
    raise unless @player.mark == "X"
  end

  it "knows about board" do
    raise unless @player.board
  end
end

describe Computer do
  before :all do
    @computer = Computer.new(mark: "O")
  end

  it "has a name" do
    raise unless @computer.name == "Computer"
  end

  it "has a mark" do
    raise unless @computer.mark == "O"
  end

  it "knows about board" do
    raise unless @computer.board
  end
end

describe Board do
  before :all do
    @board = Board.new
  end

  it "has a grid" do
    raise unless @board.grid
  end

  describe "#print_board" do
    it "exists" do
      expect(@board).to respond_to(:print_board)
    end
  end
end

describe Game do
  before :all do
    @game = Game.new
  end

  it "has a board" do
    raise unless @game.board
  end

  it "has number of players" do
    raise unless @game.players
  end

  it "has one player by default" do
    expect(@game.players).to eql(1)
  end

  it "has human players" do
    raise unless @game.human1
    raise unless @game.human2
  end

  it "has a computer player" do
    raise unless @game.computer
  end

  it "sends board to all players" do
    raise unless @game.human1.board.grid
    raise unless @game.human2.board.grid
    raise unless @game.computer.board.grid
  end

  describe "#setup" do
    it "exists" do
      expect(@game).to respond_to(:setup)
    end
  end

  describe "#set_players" do
    it "sets number of players" do
      input = @game.set_players
      expect(input).to eql(@game.players)
    end
  end
end
