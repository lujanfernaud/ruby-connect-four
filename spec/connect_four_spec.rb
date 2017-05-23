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
    @game     = Game.new
    @board    = @game.board
    @computer = @game.computer
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

  it "has hability to throw" do
    expect(@computer).to respond_to(:throw)
  end

  describe "#throw" do
    it "prints 'Computer turn...' and places mark on board" do
      expect(@board).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("Computer turn...")
      allow(@computer).to receive(:sleep)
      expect(@board).to receive(:position_mark_in_column)
      @computer.throw
    end
  end

  describe "#choose_location" do
  end

  describe "#check_rows" do
    context "on first iteration" do
      context "with 1 human mark" do
        it "returns 'false'" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "X", "-", "-"]]
          expect(@computer.check_rows(iteration: 0)).to eql(false)
          @computer.check_rows(iteration: 0)
        end
      end

      context "with 2 human marks" do
        it "returns index of first free position next to human" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "X", "-", "-"]]
          expect(@computer.check_rows(iteration: 0)).to eql(3)
          @computer.check_rows(iteration: 0)
        end
      end

      context "with 3 human marks" do
        it "returns index + 1 of first free position next to human" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["O", "O", "-", "-"],
                         ["X", "X", "X", "-"]]
          expect(@computer.check_rows(iteration: 0)).to eql(4)
          @computer.check_rows(iteration: 0)
        end
      end

      context "with 3 computer marks and 0 human marks" do
        it "returns index + 1 of first free position next to computer" do
          @board.grid = [["O", "O", "O", "-"],
                         ["X", "O", "X", "X"],
                         ["O", "O", "X", "X"],
                         ["X", "X", "O", "O"]]
          expect(@computer.check_rows(iteration: 0)).to eql(4)
          @computer.check_rows(iteration: 0)
        end
      end
    end

    context "on second iteration" do
      context "with 1 human mark" do
        it "returns index + 1 of first free position next to human" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "X", "-", "-"]]
          expect(@computer.check_rows(iteration: 1)).to eql(1)
          @computer.check_rows(iteration: 1)
        end
      end

      context "with 2 human marks" do
        it "returns index + 1 of first free position next to human" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "O", "-", "-"],
                         ["X", "X", "-", "-"]]
          expect(@computer.check_rows(iteration: 1)).to eql(3)
          @computer.check_rows(iteration: 1)
        end
      end

      context "with 2 computer marks and 0 human marks" do
        it "returns index + 1 of first free position next to computer" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["O", "O", "-", "-"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_rows(iteration: 1)).to eql(3)
          @computer.check_rows(iteration: 1)
        end
      end

      context "with 2 computer marks and 1 human mark" do
        it "returns 'false'" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["O", "O", "-", "X"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_rows(iteration: 1)).to eql(false)
          @computer.check_rows(iteration: 1)
        end
      end
    end

    context "on third iteration" do
      context "with 1 computer mark and 0 human marks" do
        it "returns index + 1 of first free position next to computer" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["O", "O", "X", "X"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_rows(iteration: 2)).to eql(2)
          @computer.check_rows(iteration: 2)
        end
      end
    end
  end

  describe "#check_columns" do
    context "on first iteration" do
      context "with no empty slots" do
        it "returns 'false'" do
          @board.grid = [["X", "O", "X", "-"],
                         ["O", "O", "X", "O"],
                         ["X", "X", "O", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_columns(iteration: 0)).to eql(false)
          @computer.check_columns(iteration: 0)
        end
      end

      context "with 1 human mark" do
        it "returns 'false'" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "X", "-", "-"]]
          expect(@computer.check_columns(iteration: 0)).to eql(false)
          @computer.check_columns(iteration: 0)
        end
      end

      context "with 2 human marks" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "O", "X"],
                         ["-", "O", "X", "X"]]
          expect(@computer.check_columns(iteration: 0)).to eql(4)
          @computer.check_columns(iteration: 0)
        end
      end

      context "with 3 human marks" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["X", "O", "-", "O"],
                         ["X", "O", "O", "X"],
                         ["X", "O", "X", "X"]]
          expect(@computer.check_columns(iteration: 0)).to eql(1)
          @computer.check_columns(iteration: 0)
        end
      end

      context "with 3 computer marks and 0 human marks" do
        it "returns column + 1" do
          @board.grid = [["O", "-", "-", "-"],
                         ["X", "O", "X", "O"],
                         ["X", "O", "O", "X"],
                         ["X", "O", "X", "X"]]
          expect(@computer.check_columns(iteration: 0)).to eql(2)
          @computer.check_columns(iteration: 0)
        end
      end
    end

    context "on second iteration" do
      context "with 1 human mark" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["-", "X", "-", "-"]]
          expect(@computer.check_columns(iteration: 1)).to eql(2)
          @computer.check_columns(iteration: 1)
        end
      end

      context "with 2 human marks" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["-", "-", "-", "-"],
                         ["X", "O", "-", "-"],
                         ["X", "X", "O", "-"]]
          expect(@computer.check_columns(iteration: 1)).to eql(1)
          @computer.check_columns(iteration: 1)
        end
      end
    end

    context "on third iteration" do
      context "with 1 computer mark and 0 human marks" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "O", "-", "-"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_columns(iteration: 2)).to eql(3)
          @computer.check_columns(iteration: 2)
        end
      end
    end
  end

  describe "#check_diagonals" do
    context "on first iteration" do
      context "with no empty slots (from left bottom)" do
        it "returns 'false'" do
          @board.grid = [["-", "-", "-", "X"],
                         ["O", "O", "O", "X"],
                         ["X", "O", "X", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(false)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with no empty slots (from right bottom)" do
        it "returns 'false'" do
          @board.grid = [["X", "O", "X", "-"],
                         ["O", "O", "X", "O"],
                         ["X", "X", "O", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(false)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 2 human marks and 0 computer marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(3)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 2 human marks and 0 computer marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "O", "X", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(2)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 3 human marks and 0 computer marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "O", "X", "O"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(4)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 3 human marks and 0 computer marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "X", "O", "-"],
                         ["X", "O", "X", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(1)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 3 computer marks and 0 human marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "O", "X"],
                         ["X", "O", "X", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_diagonals(iteration: 0)).to eql(4)
          @computer.check_diagonals(iteration: 0)
        end
      end

      context "with 3 computer marks and 0 human marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "O", "X", "X"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "X", "O"]]
          expect(@computer.diagonal_from_right_bottom(iteration: 0)).to eql(1)
          @computer.diagonal_from_right_bottom(iteration: 0)
        end
      end
    end

    context "on second iteration" do
      context "with 2 human marks and 0 computer marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 1)).to eql(3)
          @computer.check_diagonals(iteration: 1)
        end
      end

      context "with 2 human marks and 0 computer marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "O", "X", "O"],
                         ["X", "X", "O", "X"]]
          expect(@computer.check_diagonals(iteration: 1)).to eql(2)
          @computer.check_diagonals(iteration: 1)
        end
      end

      context "with 2 computer marks and 0 human marks (from left bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "O", "X", "O"],
                         ["O", "X", "X", "X"]]
          expect(@computer.check_diagonals(iteration: 1)).to eql(3)
          @computer.check_diagonals(iteration: 1)
        end
      end

      context "with 2 computer marks and 0 human marks (from right bottom)" do
        it "returns column + 1" do
          @board.grid = [["-", "-", "-", "-"],
                         ["O", "-", "-", "-"],
                         ["X", "X", "O", "O"],
                         ["X", "X", "X", "O"]]
          expect(@computer.check_diagonals(iteration: 1)).to eql(3)
          @computer.check_diagonals(iteration: 1)
        end
      end
    end
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

  describe "#first_turn" do
    it "gives turn to player and checks for winner" do
      allow(STDIN).to receive(:gets).and_return("2")
      expect(STDOUT).to receive(:puts)
      expect(@game.human1).to receive(:throw)
      expect(@game).to receive(:check_for_winner).with(@game.human1)
      @game.first_turn
    end
  end

  describe "#second_turn" do
    context "when there is 1 player" do
      it "gives turn to computer and checks for winner" do
        @game.players = 1
        expect(@game.computer).to receive(:throw)
        expect(@game).to receive(:check_for_winner).with(@game.computer)
        @game.second_turn
      end
    end

    context "when there are 2 players" do
      it "gives turn to player 2 and checks for winner" do
        @game.players = 2
        expect(STDOUT).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return("1")
        expect(@game.human2).to receive(:throw)
        expect(@game).to receive(:check_for_winner).with(@game.human2)
        @game.second_turn
      end
    end
  end

  describe "#introduce_position" do
    before do
      @game.players = 1
      expect(@game).to receive(:loop).and_yield
    end

    context "when there is only 1 player" do
      it "says 'Please introduce a position:'" do
        expect(STDOUT).to receive(:puts).with("Introduce a position:")
        allow(STDIN).to receive(:gets).and_return("4")
        @game.introduce_position(@game.human1)
      end
    end

    context "when there are 2 players" do
      it "says 'Sandi, introduce a position:'" do
        @game.players = 2
        @game.human2.name = "Sandi"
        expect(STDOUT).to receive(:puts).with("Sandi, introduce a position:")
        allow(STDIN).to receive(:gets).and_return("3")
        @game.introduce_position(@game.human2)
      end
    end

    context "when input is not a position" do
      it "says input is not correct" do
        expect(STDOUT).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return("5")
        expect(@game.board).to receive(:print_board)
        expect(STDOUT).to receive(:puts)
          .with("'5' is not a correct position.\n\nIntroduce a position:")
        @game.introduce_position(@game.human1)
      end

      it "says input is not correct" do
        expect(STDOUT).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return("22")
        expect(@game.board).to receive(:print_board)
        expect(STDOUT).to receive(:puts)
          .with("'22' is not a correct position.\n\nIntroduce a position:")
        @game.introduce_position(@game.human1)
      end

      it "exits game if input is 'exit'" do
        expect(@game.board).to receive(:print_board)
        allow(STDIN).to receive(:gets).and_return("exit")
        expect(@game).to receive(:exit)
        @game.introduce_position(@game.human1)
      end
    end
  end

  describe "#set_players" do
    it "sets number of players to 1" do
      expect(STDOUT).to receive(:puts).with("Choose players, 1 or 2?")
      allow(STDIN).to receive(:gets).and_return("1")
      @game.set_players
      expect(@game.players).to eql(1)
    end

    it "sets number of players to 2" do
      expect(STDOUT).to receive(:puts).with("Choose players, 1 or 2?")
      allow(STDIN).to receive(:gets).and_return("2")
      @game.set_players
      expect(@game.players).to eql(2)
    end
  end

  describe "#ask_players_names" do
    describe "#ask_human1_name" do
      it "asks and sets human1 name" do
        expect(@game.board).to receive(:print_board)
        expect(STDOUT).to receive(:puts).with("Player 1 name:")
        allow(STDIN).to receive(:gets).and_return("Matz")
        @game.ask_human1_name
        expect(@game.human1.name).to eql("Matz")
      end
    end

    describe "#ask_human2_name" do
      it "asks and sets human1 name" do
        expect(@game.board).to receive(:print_board)
        expect(STDOUT).to receive(:puts).with("Player 2 name:")
        allow(STDIN).to receive(:gets).and_return("Sandi")
        @game.ask_human2_name
        expect(@game.human2.name).to eql("Sandi")
      end
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

    it "checks for winner and calls #finish_game" do
      @game.board.grid = [["X", "X", "O", "X"],
                          ["O", "O", "O", "O"],
                          ["O", "X", "X", "X"],
                          ["O", "X", "O", "X"]]

      expect(@game).to receive(:check_rows)
      expect(@game).to receive(:check_columns)
      expect(@game).to receive(:check_diagonals)
      expect(@game).to receive(:finish_game)
      @game.check_for_winner(@game.human1)
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
    it "returns 'You WIN!' if there is a match (from right bottom)" do
      @game.board.grid = [["X", "X", "O", "-"],
                          ["O", "X", "O", "O"],
                          ["O", "X", "X", "X"],
                          ["O", "X", "O", "X"]]
      expect(@game).to receive(:the_winner_is).with(@game.human1)
      @game.check_diagonals(@game.human1)
    end

    it "returns 'Computer WINS!' if there is a match (from left bottom)" do
      @game.board.grid = [["-", "X", "O", "O"],
                          ["X", "X", "O", "O"],
                          ["X", "O", "X", "X"],
                          ["O", "X", "O", "X"]]
      expect(@game).to receive(:the_winner_is).with(@game.computer)
      @game.check_diagonals(@game.computer)
    end
  end

  describe "#the_winner_is" do
    context "when there is 1 player" do
      it "returns 'You WIN! Try again? (y/n)'" do
        @game.players = 1
        @game.human1.name = "Human 1"
        expect(STDOUT).to receive(:puts).with("You WIN! Try again? (y/n)")
        expect(@game).to receive(:try_again)
        @game.the_winner_is(@game.human1)
      end
    end

    context "when there is 1 player and computer wins" do
      it "returns 'Computer WINS! Try again? (y/n)'" do
        @game.players = 1
        expect(STDOUT).to receive(:puts)
          .with("Computer WINS! Try again? (y/n)")
        expect(@game).to receive(:try_again)
        @game.the_winner_is(@game.computer)
      end
    end

    context "when there are 2 players" do
      it "returns 'Sandi WINS! Try again? (y/n)'" do
        @game.players = 2
        @game.human2.name = "Sandi"
        expect(STDOUT).to receive(:puts).with("Sandi WINS! Try again? (y/n)")
        expect(@game).to receive(:try_again)
        @game.the_winner_is(@game.human2)
      end
    end
  end

  describe "#there_is_no_winner?" do
    it "returns 'true' if there are no more empty slots" do
      @game.board.grid = [["X", "X", "O", "X"],
                          ["O", "O", "O", "O"],
                          ["O", "X", "X", "X"],
                          ["O", "X", "O", "X"]]
      expect(@game.there_is_no_winner?).to eql(true)
    end
  end

  describe "#finish_game" do
    it "prints 'There's no winner. Try again? (y/n)' and calls #try_again" do
      expect(STDOUT).to receive(:puts)
        .with("There's no winner. Try again? (y/n)")
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
    it "returns 'Thanks for playing. Hope you liked it!' and exits game" do
      expect(STDOUT).to receive(:puts)
        .with("Thanks for playing. Hope you liked it!\n\n")
      expect(@game).to receive(:system).with("clear")
      expect(@game).to receive(:system).with("cls")
      expect(@game.exit_game).to raise_error SystemExit
      @game.exit_game
    end
  end
end
