require "./lib/connect_four"

describe Player do
  before :all do
    @game   = Game.new
    @player = @game.human1
    @player.name = "Matz"
    @player.mark = "X"
  end

  it "has a name" do
    expect(@player.name).to eql("Matz")
  end

  it "has a mark" do
    expect(@player.mark).to eql("X")
  end

  it "knows about board" do
    expect(@player).to respond_to(:board)
  end

  describe "#throw" do
    it "exists" do
      expect(@player).to respond_to(:throw)
    end

    it "accepts one number as an argument" do
      expect { @player.throw(2) }.not_to raise_error
    end

    it "raises ArgumentError if the paremeter is not an integer" do
      expect { @player.throw("d2") }.to raise_error(ArgumentError)
    end

    it "places mark on the grid" do
      @player.board.grid[3][1] = "X"
      @player.board.grid[2][1] = "X"
      @player.board.position_mark_in_column(2, "X")
      expect(@player.board.grid[1][1]).to eql("X")
    end
  end
end

describe Computer do
  before :all do
    @computer = Computer.new(mark: "O")
  end

  it "has a name" do
    expect(@computer.name).to eql("Computer")
  end

  it "has a mark" do
    expect(@computer.mark).to eql("O")
  end

  it "knows about board" do
    expect(@computer).to respond_to(:board)
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

  describe "#position_mark_in_column" do
    it "exists" do
      expect(@board).to respond_to(:position_mark_in_column)
    end

    it "takes position and mark as arguments" do
      expect { @board.position_mark_in_column(2, "X") }.not_to raise_error
    end

    it "checks what position is available in the column and puts mark" do
      @board.grid[3][1] = "X"
      @board.position_mark_in_column(2, "X")
      expect(@board.grid[2][1]).to eql("X")
    end
  end
end

describe Game do
  before :all do
    @game = Game.new
  end

  it "has a board" do
    expect(@game.board).to be_a(Board)
  end

  it "has number of players" do
    expect(@game.players).to be_an(Integer)
  end

  it "has one player by default" do
    expect(@game.players).to eql(1)
  end

  it "has human players" do
    expect(@game.human1).to be_a(Player)
    expect(@game.human2).to be_a(Player)
  end

  it "has a computer player" do
    expect(@game.computer).to be_a(Computer)
  end

  it "sends board to all players" do
    players = [@game.human1, @game.human2, @game.computer]
    players.each do |player|
      expect(player.board).to respond_to(:grid)
    end
  end

  describe "#setup" do
    it "exists" do
      expect(@game).to respond_to(:setup)
    end
  end

  describe "#start" do
    it "exists" do
      expect(@game).to respond_to(:start)
    end
  end

  describe "#set_players" do
    it "sets number of players" do
      input = @game.set_players
      expect(input).to eql(@game.players)
    end
  end

  describe "#ask_players_names" do
    it "asks and sets player names" do
      @game.ask_players_names
      expect(@game.human1.name).not_to eql("Human 1")
      expect(@game.human2.name).not_to eql("Human 2")
    end
  end
end
