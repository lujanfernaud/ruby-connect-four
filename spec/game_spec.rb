require "spec_helper"

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
    it "prints board, sets players, asks names if 2 and starts game" do
      expect(@game.board).to receive(:print_board)
      expect(@game).to receive(:set_players)
      expect(@game).to receive(:ask_players_names) if @game.players == 2
      expect(@game).to receive(:start)
      @game.setup
    end
  end

  describe "#start" do
    it "prints board, calls #first_turn and #second_turn" do
      allow(@game).to receive(:loop).and_yield
      expect(@game.board).to receive(:print_board)
      expect(@game).to receive(:first_turn)
      expect(@game).to receive(:second_turn)
      @game.start
    end
  end

  describe "#first_turn" do
    it "gives turn to player and checks for winner" do
      expect(@game.board).to receive(:print_board)
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
        expect(@game.board).to receive(:print_board)
        expect(STDOUT).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return("1")
        expect(@game.human2).to receive(:throw)
        expect(@game).to receive(:check_for_winner).with(@game.human2)
        @game.second_turn
      end
    end
  end

  describe "#introduce_column" do
    before do
      @game.players = 1
      expect(@game).to receive(:loop).and_yield
    end

    context "when there is only 1 player" do
      it "says 'Introduce a column:'" do
        expect(@game.board).to receive(:print_board)
        expect(STDOUT).to receive(:puts).with("Introduce a column:")
        allow(STDIN).to receive(:gets).and_return("4")
        @game.introduce_column(@game.human1)
      end
    end

    context "when there are 2 players" do
      it "says 'Sandi, introduce a column:'" do
        @game.players = 2
        @game.human2.name = "Sandi"
        expect(@game.board).to receive(:print_board)
        expect(STDOUT).to receive(:puts).with("Sandi, introduce a column:")
        allow(STDIN).to receive(:gets).and_return("3")
        @game.introduce_column(@game.human2)
      end
    end

    context "when input is not a column" do
      it "says input is not correct" do
        expect(@game.board).to receive(:print_board).twice
        expect(STDOUT).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return("5")
        expect(STDOUT).to receive(:puts)
          .with("'5' is not a correct column.\n\nIntroduce a column:")
        @game.introduce_column(@game.human1)
      end

      it "says input is not correct" do
        expect(@game.board).to receive(:print_board).twice
        expect(STDOUT).to receive(:puts)
        allow(STDIN).to receive(:gets).and_return("22")
        expect(STDOUT).to receive(:puts)
          .with("'22' is not a correct column.\n\nIntroduce a column:")
        @game.introduce_column(@game.human1)
      end

      it "exits game if input is 'exit'" do
        expect(@game.board).to receive(:print_board).twice
        expect(STDOUT).to receive(:puts).thrice
        allow(STDIN).to receive(:gets).and_return("exit")
        expect(@game).to receive(:system).with("clear")
        expect(@game).to receive(:system).with("cls")
        expect(@game).to receive(:exit)
        @game.introduce_column(@game.human1)
      end
    end
  end

  describe "#set_players" do
    before do
      allow(@game).to receive(:loop).and_yield
    end

    it "input is not correct if it's not '1' or '2'" do
      expect(STDOUT).to receive(:puts).with("Choose players, 1 or 2?")
      allow(STDIN).to receive(:gets).and_return("0")
      expect(@game.board).to receive(:print_board)
      expect(STDOUT).to receive(:puts).with("1 or 2 players?")
      @game.set_players
    end

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
        expect(@game.board).to receive(:print_board)
        expect(STDOUT).to receive(:puts).with("You WIN! Try again? (y/n)")
        expect(@game).to receive(:try_again)
        @game.the_winner_is(@game.human1)
      end
    end

    context "when there is 1 player and computer wins" do
      it "returns 'Computer WINS! Try again? (y/n)'" do
        @game.players = 1
        expect(@game.board).to receive(:print_board)
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
        expect(@game.board).to receive(:print_board)
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
      expect(@game.board).to receive(:print_board)
      expect(STDOUT).to receive(:puts)
        .with("There's no winner. Try again? (y/n)")
      expect(@game).to receive(:try_again)
      @game.finish_game
    end
  end

  describe "#try_again" do
    before do
      allow(@game).to receive(:loop).and_yield
    end

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
      expect(@game).to receive(:exit)
      @game.exit_game
    end
  end
end
