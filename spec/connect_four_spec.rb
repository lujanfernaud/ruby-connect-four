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

    it "prints board, sets players, asks names if 2 and starts game" do
      expect(@game.board).to receive(:print_board)
      expect(@game).to receive(:set_players)
      expect(@game).to receive(:ask_players_names) if @game.players == 2
      expect(@game).to receive(:start)
      @game.setup
    end
  end

  describe "#start" do
    it "exists" do
      expect(@game).to respond_to(:start)
    end
  end

  describe "#introduce_position" do
    context "when there is only 1 player" do
      it "says 'Please introduce a position:'" do
        expect(STDOUT).to receive(:puts).with("Introduce a position:")
        @game.introduce_position
      end
    end

    context "when there are 2 players" do
      it "says 'Sandi, introduce a position:'" do
        @game.players = 2
        @game.human2.name = "Sandi"
        expect(STDOUT).to receive(:puts).with("Sandi, introduce a position:")
        @game.introduce_position(@game.human2)
      end
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

  describe "#check_for_winner" do
    it "raises ArgumentError if no argument is given" do
      expect { @game.check_for_winner }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError if argument is not a Player object" do
      expect { @game.check_for_winner("Sandi") }.to raise_error(ArgumentError)
    end

    it "takes a Player as an argument" do
      expect { @game.check_for_winner(@game.human1) }.not_to raise_error
    end
  end

  describe "#check_rows" do
    it "returns 'You WIN!' if there is a four marks match in a row" do
      @game.board.grid = [["-", "-", "-", "-"],
                          ["-", "-", "O", "O"],
                          ["X", "X", "X", "X"],
                          ["O", "O", "O", "X"]]
      expect(@game).to receive(:the_winner_is).with(@game.human1)
      @game.check_rows(@game.human1)
    end
  end

  describe "#check_columns" do
    it "returns 'You WIN! if there is a four marks match in a column" do
      @game.board.grid = [["-", "X", "-", "-"],
                          ["-", "X", "O", "O"],
                          ["O", "X", "O", "X"],
                          ["O", "X", "O", "X"]]
      expect(@game).to receive(:the_winner_is).with(@game.human1)
      @game.check_columns(@game.human1)
    end
  end

  describe "#check_diagonals" do
    it "returns 'You WIN!' if there is a diagonal match (top to bottom)" do
      @game.board.grid = [["X", "X", "O", "-"],
                          ["O", "X", "O", "O"],
                          ["O", "X", "X", "X"],
                          ["O", "X", "O", "X"]]
      expect(@game).to receive(:the_winner_is).with(@game.human1)
      @game.check_diagonals(@game.human1)
    end

    it "returns 'You WIN!' if there is a diagonal match (bottom to top)" do
      @game.board.grid = [["X", "X", "O", "-"],
                          ["O", "X", "O", "O"],
                          ["O", "X", "X", "X"],
                          ["O", "X", "O", "X"]]
      expect(@game).to receive(:the_winner_is).with(@game.human1)
      @game.check_diagonals(@game.human1)
    end
  end

  describe "#the_winner_is" do
    context "when there is 1 player" do
      it "returns 'You WIN!" do
        @game.players = 1
        expect(STDOUT).to receive(:puts).with("You WIN!")
        @game.the_winner_is(@game.human1)
      end
    end

    context "when there are 2 players" do
      it "returns 'Sandi WINS!'" do
        @game.players = 2
        @game.human2.name = "Sandi"
        expect(STDOUT).to receive(:puts).with("Sandi WINS!")
        @game.the_winner_is(@game.human2)
      end
    end
  end

  describe "#there_is_no_winner" do
    it "returns 'true' if there are no more empty slots" do
      @game.board.grid = [["X", "X", "O", "X"],
                          ["O", "O", "O", "O"],
                          ["O", "X", "X", "X"],
                          ["O", "X", "O", "X"]]
      expect(@game.there_is_no_winner).to eql(true)
    end
  end

  describe "#finish_game" do
    it "prints 'There's no winner. Try again? (Y/N)' and calls #try_again" do
      expect(STDOUT).to receive(:puts)
        .with("There's no winner. Try again? (Y/N)")
      expect(@game).to receive(:try_again)
      @game.finish_game
    end
  end

  describe "#try_again" do
    it "calls Board#reset and Game#start if 'y'" do
      allow(STDIN).to receive(:gets).and_return("y")
      expect(@game.board).to receive(:reset)
      expect(@game).to receive(:start)
      @game.try_again
    end

    it "calls Game#exit_game if 'n'" do
      allow(STDIN).to receive(:gets).and_return("n")
      expect(@game).to receive(:exit_game)
      @game.try_again
    end

    it "asks to type 'y' or 'n' if none of them was typed" do
      allow(STDIN).to receive(:gets).and_return("b")
      expect(@game.board).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("Please type 'y' or 'n'.")
      @game.try_again
    end
  end

  describe "#exit_game" do
    it "returns 'Thanks for playing. Hope you liked it!'" do
      expect(STDOUT).to receive(:puts)
        .with("Thanks for playing. Hope you liked it!\n\n")
      @game.exit_game
    end
  end
end
